##############################################
#
# A Makefile for LaTeX slides.
#
# You should have a file named 'simple.tex'
# in the same directory as this. (For a 
# different name, change BASE variable below).
# Try running 'make all' and it should create
# a bunch of files - see what it does. 
#
# The 'simple.tex' file included gives
# a simple template to start from. 
# 
# Copyright (c) 2009 Ken Schutte
# Updates, documation, and more at:
# http://kenschutte.com/latex/slides
#
##############################################

BASE = simple

LATEX    = $(BASE).tex
HANDOUTS = $(BASE)_handouts
SLIDES   = $(BASE)_slides


all: 
	make slides
	make handouts
	make handouts-4up

slides:       $(SLIDES).pdf
handouts:     $(HANDOUTS).pdf
handouts-4up: $(HANDOUTS)_4up.pdf

# ----------- slides ------------------------
#   these have overlays on
# -------------------------------------------
$(SLIDES).pdf: $(SLIDES).ps
	ps2pdf $(SLIDES).ps $(SLIDES).pdf

$(SLIDES).ps: $(SLIDES).dvi
	dvips -Pexport -o $(SLIDES).ps $(SLIDES).dvi

$(SLIDES).dvi: $(SLIDES).tex
# need to run 'latex' twice if there are toc, bib, etc..
	latex $(SLIDES).tex
	latex $(SLIDES).tex

$(SLIDES).tex: $(BASE).tex
	echo "% DONT EDIT THIS FILE... CREATED BY Makefile" >  $(SLIDES).tex
	echo "%    (use tex file without _slides suffix)  " >> $(SLIDES).tex
	echo "% ------------------------------------------" >> $(SLIDES).tex
	sed -e 's/^\\overlaysfalse/\\overlaystrue/' $(BASE).tex >> $(SLIDES).tex

# ----------- handouts ------------------------
#   these have overlays off
# ---------------------------------------------

$(HANDOUTS)_4up.pdf: $(HANDOUTS)_4up.ps
	ps2pdf $(HANDOUTS)_4up.ps $(HANDOUTS)_4up.pdf

$(HANDOUTS)_4up.ps: $(HANDOUTS).ps
	## Newer version of psnup uses '-n 4' instead (?)
	#psnup -nup 4 -l $(HANDOUTS).ps > $(HANDOUTS)_4up.ps
	psnup -n 4 -l $(HANDOUTS).ps > $(HANDOUTS)_4up.ps

$(HANDOUTS).pdf: $(HANDOUTS).ps
	ps2pdf $(HANDOUTS).ps $(HANDOUTS).pdf

$(HANDOUTS).ps: $(HANDOUTS).dvi
	dvips -Pexport -o $(HANDOUTS).ps $(HANDOUTS).dvi

$(HANDOUTS).dvi: $(HANDOUTS).tex
# need to run 'latex' twice if there are toc, bib, etc..
	latex $(HANDOUTS).tex
	latex $(HANDOUTS).tex

$(HANDOUTS).tex: $(BASE).tex
	echo "% DONT EDIT THIS FILE... CREATED BY Makefile" >  $(HANDOUTS).tex
	echo "%    (use tex file without _handouts suffix)" >> $(HANDOUTS).tex
	echo "% ------------------------------------------" >> $(HANDOUTS).tex
	sed -e 's/^\\overlaystrue/\\overlaysfalse/' $(BASE).tex >> $(HANDOUTS).tex

clean:
	make clean-slides
	make clean-handouts
	make clean-handouts-4up

clean-slides:
	rm -f $(SLIDES).pdf $(SLIDES).ps $(SLIDES).dvi $(SLIDES).tex  $(SLIDES).aux $(SLIDES).log $(SLIDES).toc $(SLIDES).out
clean-handouts:
	rm -f $(HANDOUTS).pdf $(HANDOUTS).ps $(HANDOUTS).dvi $(HANDOUTS).tex $(HANDOUTS).aux $(HANDOUTS).log $(HANDOUTS).toc $(HANDOUTS).out
clean-handouts-4up:
	rm -f $(HANDOUTS)_4up.pdf $(HANDOUTS)_4up.ps

