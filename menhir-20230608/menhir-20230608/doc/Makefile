.PHONY: all view loop clean check

export TEXINPUTS=.:

DEPS = $(wildcard *.tex) $(wildcard *.bib) $(wildcard *.sty) $(wildcard *.mly)

all: manual.pdf manual.html

%.pdf: %.tex $(DEPS)
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

manual.html: manual.tex $(DEPS) $(wildcard *.hva)
	hevea -fix manual.tex
#
# Hevea interprets 'tabbing' environment in a way
# that creates spacing errors in the rendered output
# of "textual version of derivation trees": it
# asks for (padding:0px;) while the TeX rendering
# inserts spacing between columns. Change this
# to {padding:1px;}
	sed -i.bak -e "s/cellpadding0/cellpadding1/" manual.html && rm manual.html.bak
#
# Note: hevea generates images manual00{1,2,3}.png for the tikz pictures
# present in the manual.

view:
	latexmk -pdf -pv manual

loop:
	latexmk -pdf -pvc manual

clean:
	@ rm -f `cat .gitignore`

CHECK := manual.tex

check:
	@ for f in $(CHECK) ; do \
	  aspell --mode=tex --lang=en_US --encoding=utf-8 \
	         --home-dir=. --personal=.aspell.en.pws \
	         check $$f ; \
	done
