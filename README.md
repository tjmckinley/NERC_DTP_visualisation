# Lecture notes

This repo contains lecture notes and slides for a data visualisation workshop.

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

Remember links are hard-coded so they work in the PDF.

## To publish using `gh-pages`

One way to publish this online is to use the `gh-pages` branch on GitHub. **The following assumes that your source code is in the `NERC_DTP_visualisation` branch, and that no uncommitted changes exist in the repo. You have been warned!**

Firstly, build your document, which should place all files in a `docs` folder. Then, copy the file `.nojekyll` into `docs/` (this is required to make sure figures render correctly when deployed). If using `_build.sh`
theen this is done automatically.

**Assuming that the branch `tempBranch` does not exist**, then on the command line run:

```
git checkout NERC_DTP_visualisation
git checkout -b tempBranch
git add -f docs
git commit -m "Added docs to repo"
git subtree split --prefix docs -b gh-pages
git push origin gh-pages --force
```

At this point the page has been deployed, and can be found at `https://USERNAME.github.io/REPONAME/`, where `USERNAME` and `REPONAME` should be replaced appropriately. You can see this deployment here:

[https://tjmckinley.github.io/NERC_DTP_visualisation/](https://tjmckinley.github.io/NERC_DTP_visualisation/)

Next, you might want to store a copy of the `docs` folder, since the next set of `git` commands will remove it. On the command line this can be done as:

```
rm docs.zip
zip -r docs.zip docs/
```

Finally, clean up your repo:

```
git checkout NERC_DTP_visualisation
git branch -D gh-pages tempBranch
```


