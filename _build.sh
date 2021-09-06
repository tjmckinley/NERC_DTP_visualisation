#!/bin/sh

## clean up folder
rm -rf docs/

## compile notes
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

## copy nojekyll file
cp .nojekyll docs/

## compile lecture slides
cd slides
./compile.sh -p IntroToR
./compile.sh -p IntroToR -b 1
./compile.sh -p IntroToR -h 1
cd ..

## copy required files to uploadFiles
cp intro/uploadFiles/* docs/intro/uploadFiles
if [ -f intro/datasetsIntro.zip ]; then
    rm intro/datasetsIntro.zip
fi
zip -rj intro/datasetsIntro.zip intro/uploadFiles
cp intro/datasetsIntro.zip docs/intro/uploadFiles/
cp slides/IntroToR/IntroToRSLIDES* docs/intro/uploadFiles/
cp slides/IntroToR/IntroToRHANDOUT* docs/intro/uploadFiles/

## create zip for ELE
rm docs.zip
zip -r docs.zip docs



# ## copy required files for workshop
# cp dataFiles.zip docs/
# cp AdVisSlides/AdVisHandout.pdf docs/
# cp DataWrSlides/DataWrHandout.pdf docs/
# cd docs
# zip slides.zip AdVisHandout.pdf DataWrHandout.pdf
# cd ..
# mkdir docs/uploadFiles
# cp -r advis/uploadFiles/* docs/uploadFiles

