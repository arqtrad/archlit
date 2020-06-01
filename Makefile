VPATH = lib
vpath %.bib bibliography
vpath %.csl styles
vpath %.yaml .:spec:_data
vpath default.% lib

SRC  = $(wildcard *.md)
TMP := $(patsubst %,tmp/%, $(SRC))

build : $(TMP)
	bundle exec jekyll build 2>&1 | egrep -v 'deprecated|obsoleta'

tmp/%.md : %.md jekyll.yaml lib/templates/default.jekyll
	docker run --rm -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/core:2.9.2.1 $< -o $@ -d spec/jekyll.yaml

%.pdf : %.md biblio.bib pdf.yaml
	docker run --rm -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/latex:2.9.2.1 $< -d spec/pdf.yaml -o $@

%.docx : %.md biblio.bib docx.yaml
	docker run --rm -v "`pwd`:/data" --user `id -u`:`id -g` \
		palazzo/pandoc-xnos:2.3.0 $< -d spec/docx.yaml -o $@

_site/%.html : %.md biblio.bib html.yaml
	docker run --rm -v "`pwd`:/data" --user `id -u`:`id -g` \
		palazzo/pandoc-xnos:2.3.0 $< -d spec/docx.yaml -o $@
