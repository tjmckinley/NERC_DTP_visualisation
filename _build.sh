#!/bin/bash

# -s compile slides

while getopts :s: option
do
    case "${option}"
    in
        s) slides=${OPTARG};;
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

# check slides mode (1 = compile, 0 = don't compile slides)
if [ ! -z ${slides+x} ]; then
    if [ $slides != "0" ] && [ $slides != "1" ]; then
        echo "slides set incorrectly (should be 0 = don't compile slides or 1 = compile slides)"
        exit 1
    fi
else
    slides="1"
fi

## clean up folder
rm -rf docs/

## compile notes
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

## copy nojekyll file
cp .nojekyll docs/

## declare array variables
chNames=("intro" "prog" "simpleplots" "advis" "datawr" "covid" "spatialCovid" "litprog" "git")
chPaths=("intro" "intro" "intro" "advis" "advis" "covid" "covid" "litprog" "git")

## get length of an array
arraylength=${#chNames[@]}

for (( i=0; i<${arraylength}; i++ )); 
do
    ## extract name and path
    chName=${chNames[$i]}
    chPath=${chPaths[$i]}

    ## compile lecture slides
    if [ $slides == "1" ]; then
        cd slides
        ./compile.sh -p $chName
        ./compile.sh -p $chName -b 1
        ./compile.sh -p $chName -h 1
        cd ..
    fi
    
    ## copy required files to uploadFiles
    mkdir -p docs/$chPath/uploadFiles
    if [ -d $chPath/uploadFiles ]; then
        cp $chPath/uploadFiles/* docs/$chPath/uploadFiles
        if [ -f $chPath/datasets_${chPath}.zip ]; then
            rm $chPath/datasets_${chPath}.zip
        fi
        zip -rj $chPath/datasets_${chPath}.zip $chPath/uploadFiles
        mv $chPath/datasets_${chPath}.zip docs/$chPath/uploadFiles/
    fi
    cp slides/$chName/${chName}SLIDES* docs/$chPath/uploadFiles/
    cp slides/$chName/${chName}HANDOUT* docs/$chPath/uploadFiles/
done

## create zip for ELE
rm docs.zip
zip -r docs.zip docs

