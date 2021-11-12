#!/bin/bash

# -p path to target directory (required)
# -f .Rmd filename (with suffix removed) (if not set, will 
#   search for a suitable option or return an error if
#   more than one possibility found
# -b use beamer if 1
# -h compile handouts if 1
# -c clean up output files if 1

while getopts :p:f:b:h:c: option
do
    case "${option}"
    in
        p) target=${OPTARG};;
        f) texfile=${OPTARG};;
        b) beamer=${OPTARG};;
        h) handoutmode=${OPTARG};;
        c) cleanup=${OPTARG};;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

# check all arguments exist where necessary
if [ -z ${target+x} ]; then
    echo "Directory argument required."
    exit 1
fi

# check there is no slash at the end of the path argument
target=${target%/}

# check that target directory exists
if [ ! -d $target ]; then
    echo "$target directory does not exist"
    exit 1
fi

# check handout mode (1 = handout, 0 = slides)
if [ ! -z ${handoutmode+x} ]; then
    if [ $handoutmode != "0" ] && [ $handoutmode != "1" ]; then
        echo "handoutmode set incorrectly (should be 0 = slides or 1 = handout)"
        exit 1
    fi
else
    handoutmode="0"
fi

# check beamer mode (1 = beamer, 0 = HTML)
if [ ! -z ${beamer+x} ]; then
    if [ $beamer != "0" ] && [ $beamer != "1" ]; then
        echo "beamer set incorrectly (should be 0 = HTML or 1 = beamer)"
        exit 1
    fi
else
    if [ $handoutmode == "1" ]; then
        beamer="1"
    else
        beamer="0"
    fi
fi

# check handout mode
if [ $beamer == "0" ] && [ $handoutmode == "1" ]; then
    echo "beamer must be used to generate handouts"
    exit 1
fi

# check cleanup (1 = cleanup, 0 = leave output files)
## cleans up by default
if [ ! -z ${cleanup+x} ]; then
    if [ $cleanup != "0" ] && [ $cleanup != "1" ]; then
        echo "cleanup set incorrectly (should be 0 = leave output files or 1 = cleanup)"
        exit 1
    fi
else
    cleanup="1"
fi

# change to target directory
cd $target

# if no .Rmd file argument is given, then search for relevant files
# else use the specified file
if [ -z ${texfile+x} ]; then 
    # search for .Rmd files
    texfile=(*.Rmd)
    nfile=${#texfile[@]}
    if [ $nfile -gt 1 ]; then
        echo "More than one possible .Rmd file - must specify"
        exit 1
    else
        if [ $nfile -eq 0 ]; then
            echo "No .Rmd files in directory"
            exit 1
        fi
    fi
    texfile=${texfile%%.Rmd}
else
    # check texfile exists
    if [ ! -e "$texfile.Rmd" ]; then 
        echo "No file called \"$texfile.Rmd\""
        exit 1
    fi
fi

# set argument for passing to latex
compile="$texfile.Rmd"
cp ../setupFiles/_render.R .

# compile handouts
if [ $beamer == "1" ]; then
    if [ $handoutmode == "1" ]; then
        command="R CMD BATCH --no-save --no-restore --slave \"--args $compile beamer_presentation TRUE\" _render.R"
        eval $command
        pdfannotextractor ${texfile}.pdf
        compile="\def\filename{${texfile}.pdf} \input{../setupFiles/_handout.tex}"
        pdflatex $compile
        mv _handout.pdf ${texfile}HANDOUT.pdf
        if [ $cleanup == "1" ]; then
            gio trash *.aux ${texfile}.pax ${texfile}.pdf *.log
        fi
    else
        # compile the latex document
        command="R CMD BATCH --no-save --no-restore --slave \"--args $compile beamer_presentation FALSE\" _render.R"
        eval $command
        mv ${texfile}.pdf ${texfile}SLIDES.pdf
    fi
    if [ $cleanup == "1" ]; then
        gio trash _render.R*
    fi
else
    # compile the HTML slides
    command="R CMD BATCH --no-save --no-restore --slave \"--args $compile revealjs::revealjs_presentation FALSE\" _render.R"
    eval $command
    mv ${texfile}.html ${texfile}SLIDES.html
    if [ $cleanup == "1" ]; then
        gio trash _render.R*
    fi
fi

# change back to main directory
cd ..

exit 0
