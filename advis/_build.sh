#!/bin/sh

rm -rf docs/

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

## copy nojekyll file
cp .nojekyll docs/

## copy required files for workshop
cp dataFiles.zip docs/
cp AdVisSlides/AdVisHandout.pdf docs/
cp DataWrSlides/DataWrHandout.pdf docs/
cd docs
zip slides.zip AdVisHandout.pdf DataWrHandout.pdf
cd ..

