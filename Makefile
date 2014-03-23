DOCUMENT := hacksheet.tex
LATEX := pdflatex
BIBTEX := bibtex

RERUN := "(undefined references|Rerun to get (cross-references|the bars|point totals) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB := "No file.*\.bbl|Citation.*undefined"

all: $(DOCUMENT:.tex=.pdf)

latexmk:
	@latexmk -pvc -pdf $(DOCUMENT)

purge:
	-rm -f *.{aux,bbl,blg,dvi,fdb_latexmk,fls,log,out,thm,toc}

clean: purge
	-rm -f $(DOCUMENT:.tex=.pdf)

web: $(DOCUMENT:.tex=.pdf)
	@scp $(DOCUMENT:.tex=.pdf) cybertea@cyberteam.berkeley.edu:~/public_html/

%.pdf: %.tex
	$(LATEX) $<
	@egrep -q $(RERUNBIB) $*.log && $(BIBTEX) $* && $(LATEX) $<; true
	@egrep -q $(RERUN) $*.log && $(LATEX) $<; true
	@egrep -q $(RERUN) $*.log && $(LATEX) $<; true
	-@egrep -qi undefined $*.log && printf '\n=== Undefined ====\n\n' && egrep -i undefined $*.log && echo

.SUFFIXES: .tex .pdf .aux .dvi .log .bbl .blg .thm .out
