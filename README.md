# pandoc-docker

This creates a docker image for pandoc/markdown/latex, geared for generating astro papers specifically.

It installs pandoc, texlive, pandoc-crossref, pandoc-citeproc, and some custom scripts for shepherding a markdown document through to submittable tex and PDF.

The docker image is ~3GB, but no worries about keeping pandoc and the various filters in sync.

## Usage

``docker pull coljac/pandoc-markdown``

``docker run -v `pwd`:/docs --rm --entrypoint md_to_pdf coljac/pandoc-markdown filename``

Citation style files courtesy https://github.com/citation-style-language/styles
