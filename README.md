# Lecture notes

This repo contains lecture notes and slides for CSC3031 Applied Data Science 
module. 

To completely compile all of the lecture notes, one can run the `_build.sh` 
script. This will compile all lecture slides and lecture notes, and create
a compressed `.zip` file that can be uploaded to ELE. When setting the 
`chNames` and `chPath` variables:

* Upload files are zipped according to `$chPath/dataFiles${chName}.zip`.
* Slides should be located in `slides/$chName/${chName}.Rmd`.

To do this, upload the `docs.zip` to ELE as a `File` (not `Folder`), then
click on the uploaded file and unzip it, then click on the folder, locate
the `index.html` file and set this to be the **Main File**. Then all
links should work.

Remember to remove relative links from the PDF, but these can be included
in the HTML.
