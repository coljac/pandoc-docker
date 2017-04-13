FROM ubuntu:16.10

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
RUN mkdir -p /root/texmf/tex/latex /root/texmf/bibtex/bst
RUN wget http://mirrors.ctan.org/macros/latex/contrib/mnras.zip && unzip mnras.zip && mv mnras /root/texmf/tex/latex && rm mnras.zip
RUN find /root/texmf/tex/latex | grep bst | xargs -I@ cp @ /root/texmf/bibtex/bst
RUN mktexlsr && texhash && kpsewhich mnras.cls && kpsewhich mnras.bst 
RUN mkdir /docs

ENV PATH /root/.cabal/bin:/src/bin:$PATH

COPY src /src
COPY test /test

WORKDIR /docs

ENTRYPOINT ["pandoc"]
CMD ["--help"]
