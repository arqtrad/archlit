VPATH = lib
vpath %.bib bibliography
vpath %.csl styles
vpath %.yaml .:spec:_data
vpath default.% lib

SRC  = $(filter-out README.md,$(wildcard *.md))

%.pdf : %.md biblio.bib pdf.yaml
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		palazzo/pandoc-crossref:2.9.2.1 $< -d pdf.yaml -o $@

%.docx : %.md biblio.bib docx.yaml
	@test -e styles || git clone https://github.com/citation-style-language/styles.git
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		palazzo/pandoc-crossref:2.9.2.1 $< -d docx.yaml -o $@

_site/%.html : %.md biblio.bib jekyll.yaml
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		palazzo/pandoc-crossref:2.9.2.1 $< -d jekyll.yaml -o $@

clean :
	-rm -rf styles
# vim: set shiftwidth=2 tabstop=2 :
