VPATH = lib
vpath %.bib bibliography
vpath %.csl styles
vpath %.yaml .:spec:_data
vpath default.% lib

SRC  = $(filter-out README.md,$(wildcard *.md))

palazzo-tdsr-30-article.docx : article.md biblio.bib docx.yaml spec/tdsr.docx
	@test -e styles || git clone https://github.com/citation-style-language/styles.git
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 $< -d docx.yaml \
		--reference-doc=spec/tdsr.docx -o $@

%.pdf : %.md biblio.bib pdf.yaml
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 $< -d pdf.yaml -o $@

%.docx : %.md biblio.bib docx.yaml
	@test -e styles || git clone https://github.com/citation-style-language/styles.git
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 $< -d docx.yaml -o $@

_site/%.html : %.md biblio.bib jekyll.yaml
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 $< -d jekyll.yaml -o $@

%.json : %.yaml spec/yaml2json.js
	docker run --rm -it -v "`pwd`:/usr/src/app" -w /usr/src/app \
		--user "`id -u`:`id -g`" node:12.18-alpine \
		yarn && node spec/yaml2json.js $< >> $@

build :
	docker run --rm -v "`pwd`:/srv/jekyll" jekyll/jekyll:4.1.0 \
		/bin/bash -c "chmod 777 /srv/jekyll && jekyll build"

clean :
	-rm -rf styles
# vim: set shiftwidth=2 tabstop=2 :
