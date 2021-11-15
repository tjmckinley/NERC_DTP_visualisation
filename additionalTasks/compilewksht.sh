#!/bin/bash

# -p path to target directory (required)
# -f .Rmd filename (with suffix removed) (if not set, will 
#   search for a suitable option or return an error if
#   more than one possibility found
# -s sets option to compile with answers
# -m sets option to compile with mark scheme
# -a sets option to compile in all formats
# -r sets option to compile rmarkdown answer sheet

while getopts :p:f:s:m:a:r: option
do
    case "${option}"
    in
        p) target=${OPTARG};;
        f) Rmdfile=${OPTARG};;
        s) showanswers=${OPTARG};;
        m) showmark=${OPTARG};;
        a) compileall=${OPTARG};;
        r) rmarkdown=${OPTARG};;
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

# copy render file to target directory
cp setupFiles/render.R $target

# change to target directory
cd $target

# if no .Rmd file argument is given, then search for relevant files
# else use the specified file
if [ -z ${Rmdfile+x} ]; then 
    #search for .Rmd files
    Rmdfile=(*.Rmd)
    nfile=${#Rmdfile[@]}
    if [ $nfile -gt 1 ]; then
        echo "More than one possible .Rmd file - must specify"
        exit 1
    else
        if [ $nfile -eq 0 ]; then
            echo "No .Rmd files in directory"
            exit 1
        fi
    fi
    Rmdfile=${Rmdfile%%.Rmd}
else
    #check Rmdfile exists
    if [ ! -e "$Rmdfile.Rmd" ]; then 
        echo "No file called \"$Rmdfile.Rmd\""
        exit 1
    fi
fi

# see whether to compile all variations
if [ ! -z ${compileall+x} ]; then
    if [ $compileall != "0" ] && [ $compileall != "1" ]; then
        echo "compileall set incorrectly (should be 0 or 1)"
        exit 1
    fi
else
    compileall=0
fi

# compile template answer sheet
if [ ! -z ${rmarkdown+x} ]; then
    if [ $rmarkdown != "0" ] && [ $rmarkdown != "1" ]; then
        echo "rmarkdown set incorrectly (should be 0 or 1)"
        exit 1
    fi
else
    rmarkdown=0
fi

if [ $compileall != "1" ]; then
    # if necessary compile according to specific flags

    # check whether showanswers required (1 = yes, 0 = no)
    if [ ! -z ${showanswers+x} ]; then
        if [ $showanswers != "0" ] && [ $showanswers != "1" ]; then
            echo "showanswers set incorrectly (should be 0 or 1)"
            exit 1
        fi
        if [ $showanswers == "1" ]; then
            compile="TRUE"
        else
            compile="FALSE"
        fi
    else 
        compile="FALSE"
    fi

    # check whether showmark required (1 = yes, 0 = no)
    if [ ! -z ${showmark+x} ]; then
        if [ $showmark != "0" ] && [ $showmark != "1" ]; then
            echo "showmark set incorrectly (should be 0 or 1)"
            exit 1
        fi
        if [ $showmark == "1" ]; then
            compile="$compile TRUE"
        else
            compile="$compile FALSE"
        fi
    else
        compile="$compile FALSE"
    fi

    # compile the document
    command="R CMD BATCH --no-save --no-restore --slave \"--args $Rmdfile.Rmd $compile\" render.R "
    eval $command
else
    # here compile both question and answer scripts
    
    # compile questions
    compile="FALSE FALSE"
    command="R CMD BATCH --no-save --no-restore --slave \"--args $Rmdfile.Rmd $compile\" render.R "
    eval $command
    mv ${Rmdfile}.pdf ${Rmdfile}QUESTIONS.pdf
    
    #compile answers 
    compile="TRUE FALSE"
    command="R CMD BATCH --no-save --no-restore --slave \"--args $Rmdfile.Rmd $compile\" render.R "
    eval $command
    mv ${Rmdfile}.pdf ${Rmdfile}ANSWERS.pdf
    
   #compile answers with mark scheme
   compile="TRUE TRUE"
   command="R CMD BATCH --no-save --no-restore --slave \"--args $Rmdfile.Rmd $compile\" render.R "
   eval $command
   mv ${Rmdfile}.pdf ${Rmdfile}MARK.pdf
fi

# delete render file
rm render.R render.Rout

# change back to main directory
cd ..

if [ $rmarkdown == "1" ]; then
    # compile template answer sheet
    command="R CMD BATCH --no-save --no-restore --slave \"--args $target\" setupFiles/createMarkdown.R "
    eval $command
    rm *.Rout
fi

exit 0
