## Template for `reveal.js` slides

This template provides a means of producing HTML slides using `reveal.js` and `rmarkdown`. It will also produce thematically similar slides from the same code using the LaTeX beamer package.

Full options for `reveal.js` can be found:

[https://revealjs.com/](https://revealjs.com/)

This template provides a custom `columns` chunk which is often useful (see template for usage example).

This is helpful because the HTML slides compile mathematics using MathJax, which is accessible to screen readers. It also provides a virtual chalkboard plugin, which is helpful for mathematics teaching, see:

[https://rajgoel.github.io/reveal.js-demos/chalkboard-demo.html#/](https://rajgoel.github.io/reveal.js-demos/chalkboard-demo.html#/)

More features will be added as I need/think of them.

Keep each lecture in a separate folder starting with `lecture` e.g. `lecture1/` and so on with each folder contains an `.Rmd` file to be compiled into slides.

To compile HTML slides, then from the **main directory** run:

```{bash, eval = FALSE}
./compile.sh -p lecture1
```

This bash script generates the correct HTML document inside the corresponding lecture folder. To compile PDF slides run

```{bash, eval = FALSE}
./compile.sh -p lecture1 -b 1
```

To compile 4x4 PDF handouts run

```{bash, eval = FALSE}
./compile.sh -p lecture1 -b 1 -h 1
```

To compile all lecture slides, handouts and create a single PDF handout for all lectures, run

```{bash, eval = FALSE}
./compileall.sh
```

## Installation of $\LaTeX$ packages

The `mtheme` style and Fira Sans fonts can be installed using `tinytex`.

## Installing `pax` and `pdfbox`

To preserve hyperlinks in the PDF you need to use `pax`, which can be installed using `tinytex`. Also need to install `PDFBox 0.7.3`. To do this uninstall PDFBox using Synaptic, and then run:

```
pdfannotextractor --install
```

Also need java:

```
sudo apt-get install default-jdk
```

