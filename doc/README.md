# `doc`

This directory contains the resulting documentation of the project. Note that
it is written in German.

To build a PDF-Version of `doc.md`, run the following command in this directory.

```
$ docker run --rm -v "$(pwd):/data" pandoc/latex doc.md \
    --shift-heading-level-by=-1 --citeproc -o doc.pdf
```
