LATEX=latexmk -pdf -xelatex

test.pdf: hw07.bare_tex


%.pdf: %.tex
	$(LATEX) $< -jobname=$(basename $@ .pdf)

# lyx can't accept an exort filename, so just move the file after
%.lyx_tex: %.lyx
	lyx --export latex $<
	mv $(patsubst %.lyx,%.tex,$<) $@

# remove newlines so sed can work multiline, cut everyting until
# \begin{document}, add newlines back and remove the outside document env. Now
# its suitable for \input-ing from another file.
%.bare_tex: %.lyx_tex
	cat $< |\
	  tr '\n' '\r' |\
	  sed 's/^.*\\begin{document}//' |\
	  tr '\r' '\n' | sed -e 's/\\begin{document}//' -e 's/\\end{document}//' > $@


# it is what it is
clean:
	rm -f ./*.aux ./*.auxlock ./*.fdb_latexmk ./*.fls ./*.xdv ./*.bbl ./*.brf ./*.blg ./*.log ./*.out ./*.synctex.gz ./*.fmt ./*.atfi ./*.dvi ./*.md5 ./*.dpth ./*.auxlock ./*.cot ./*.tex.map ./*.idx ./*.ilg ./*.toc ./*.ind ./*.lyx_tex ./*.bare_tex
