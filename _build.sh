#!/bin/sh

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
#Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
#Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"

## copy nojekyll file
cp .nojekyll docs/

## copy required files for workshop
cp dataFiles.zip docs/
