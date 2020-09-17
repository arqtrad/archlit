VPATH = lib
vpath %.bib bibliography
vpath %.csl styles
vpath %.yaml .:spec:_data
vpath default.% lib

SRC  = $(filter-out README.md,$(wildcard *.md))

docs/index.html : slides.md revealjs.yaml biblio.bib | styles
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 $< -d spec/revealjs.yaml -o $@

palazzo-tdsr-30-article.docx : article.md biblio.bib docx.yaml spec/tdsr.docx | styles
	docker run -v "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/crossref:2.10 $< -d docx.yaml \
		--reference-doc=spec/tdsr.docx -o $@

styles :
	@test -e styles || git clone https://github.com/citation-style-language/styles.git

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
	docker run -v "`pwd`:/srv/jekyll" jekyll/jekyll:4.1.0 \
		/bin/bash -c "chmod 777 /srv/jekyll && jekyll build"

serve :
	docker run -v "`pwd`:/srv/jekyll" -h 127.0.0.1 -p 4000:4000 \
		jekyll/jekyll:4.1.0 \
		/bin/bash -c "jekyll serve --skip-initial-build"

clean :
	-rm -rf styles
# vim: set shiftwidth=2 tabstop=2 :
