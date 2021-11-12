#!/bin/bash

# script compiles all handouts and binds together into
# single PDF

files=""
for i in lecture*/; do
    DIR=$(basename "$i")
    echo $i
    ./compile.sh -p $i -h 1
    cd $DIR
    texfile=(*.Rmd)
    nfile=${#texfile[@]}
    if [ $nfile -gt 1 ]; then
        echo "Too many .Rmd files"
        exit 1
    else
        texfile=${texfile%.Rmd}
        if [ ! -e "${texfile}HANDOUT.pdf" ]; then 
            echo "\"${texfile}HANDOUT.pdf\" didn't compile properly"
            exit 1
        fi
        files="$files ${texfile}HANDOUT.pdf"
        cp ${texfile}HANDOUT.pdf ..
    fi
    cd ..
done
echo $files

command="pdftk $files cat output lecturenotes.pdf"
eval $command
gio trash *HANDOUT.pdf

exit 0
