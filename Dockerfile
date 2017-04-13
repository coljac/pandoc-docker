FROM ubuntu:16.10

# Install all the necessary software
RUN apt-get update && apt-get install -y --no-install-recommends \
                texlive \
                texlive-lang-cjk \
                texlive-luatex \
                texlive-xetex \
                lmodern \
                unzip \
                wget \
        && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y haskell-platform 
RUN cabal update && cabal install pandoc-crossref && cabal install pandoc-citeproc
RUN apt-get install -y python-pip
RUN pip install pandocfilters

# Set up the LaTeX environment to have the astro classes and styles
COPY classes.txt /tmp
RUN mkdir -p /root/texmf/tex/latex /root/texmf/bibtex/bst
RUN wget -i /tmp/classes.txt 
RUN bash -c 'for z in *zip; do unzip -d /root/texmf/tex/latex $z; done'
RUN rm *.zip /tmp/classes.txt

RUN find /root/texmf/tex/latex | grep bst | xargs -I@ cp @ /root/texmf/bibtex/bst
RUN mktexlsr && texhash && kpsewhich mnras.cls && kpsewhich mnras.bst 
RUN mkdir /docs

ENV PATH /root/.cabal/bin:/src/bin:$PATH

COPY src /src

WORKDIR /docs

ENTRYPOINT ["md_to_tex"]
# CMD ["--help"]
