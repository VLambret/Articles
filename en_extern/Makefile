all : result.html

clean :
	rm -f result.* a.out *.png *.ps tmp2

result.html : result.md
	pandoc -s $< -o $@
	#pandoc --css pandoc.css -s $< -o $@

result.md : text.md include_c.sh
	./include_c.sh $< > $@

.PHONY : main.png

main.png : main.c version.c
	enscript --borders --file-align=1 --color -F Courier30 -f Courier24 --header='|$$N|' -1 --highlight=c -h --margins=0:0:0:0 $^ -o - |\
	psnup -n2 |\
	convert - -density 100 -trim -border 0 -rotate 90 $@
	convert $@ -bordercolor Tomato -border 0x50 -gravity South -chop 0x50 -fuzz 30% -gravity South -trim $@

test :
	cat tmp2 | ../enscript/ansifilter/src/ansifilter -M -o pango_test2.txt
	/home/lambret/git/ImageMagick/install/bin/convert -background black -density 150% pango:@pango_test2.txt  pango_test.png
