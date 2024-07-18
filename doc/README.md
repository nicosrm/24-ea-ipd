# `doc`

This directory contains the resulting documentation of the project, once as
a [`pandoc`](https://pandoc.org/) markdown file and once as a in GitHub
previewable [GitHub Flavoured Markdown](https://github.github.com/gfm/) (GFM)
file.

To build the GFM version, run the following command in this directory.

```
$ docker run --rm -v "$(pwd):/data" pandoc/latex doc.pandoc.md \
    --shift-heading-level-by=-1 --citeproc --to=gfm -o doc.preview.md
```

To build a PDF version of the documentation, run the following command in this
directory.

```
$ docker run --rm -v "$(pwd):/data" pandoc/latex doc.pandoc.md \
    --shift-heading-level-by=-1 --citeproc -o doc.pdf
```

Note that the documentation is written in German.
