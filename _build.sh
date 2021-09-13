#!/bin/bash

## clean up folder
rm -rf docs/

## compile notes
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

## copy nojekyll file
cp .nojekyll docs/

## declare an array variable
chNames=("intro" "advis")
chPaths=("intro" "advis")

## get length of an array
arraylength=${#chNames[@]}

for (( i=0; i<${arraylength}; i++ )); 
do
    ## extract name and path
    chName=${chNames[$i]}
    chPath=${chPaths[$i]}

    ## compile lecture slides
    cd slides
    ./compile.sh -p $chName
    ./compile.sh -p $chName -b 1
    ./compile.sh -p $chName -h 1
    cd ..
    
    ## copy required files to uploadFiles
    cp $chPath/uploadFiles/* docs/$chPath/uploadFiles
    if [ -f $chPath/datasets$chPath.zip ]; then
        rm $chPath/datasets$chPath.zip
    fi
    zip -rj $chPath/datasets$chName.zip $chPath/uploadFiles
    mv $chPath/datasets$chPath.zip docs/$chPath/uploadFiles/
    cp slides/$chName/${chName}SLIDES* docs/$chPath/uploadFiles/
    cp slides/$chName/${chName}HANDOUT* docs/$chPath/uploadFiles/
done

## create zip for ELE
rm docs.zip
zip -r docs.zip docs

