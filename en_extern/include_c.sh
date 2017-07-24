#! /bin/bash

LANG=
IMG_BASE=$1
IMG_COUNTER=0

function include_c() {
	for FILE in $*;
	do
		echo "**$FILE**"
		echo '```C'
		cat $FILE
		echo '```'
	done
}


function include_src2img() {
	IMG_COUNTER=$(( $IMG_COUNTER + 1))
	IMG_NAME=$IMG_BASE.$IMG_COUNTER.png
	./src2img.sh $* $IMG_NAME
	echo "![]($IMG_NAME)"
}

COMMAND_OUTPUT=

function print_prompt() {
        echo -n "[1;37;40mvictor@sogilis\$[0;37;40m "
}

function print_command {
	print_prompt
	echo -n "$*"
	echo
	$* 2> >(sed $'s,.*,\e[31m&\e[m,' | fmt >&2)
}

function print_aout {
	if [ -f a.out ];
	then
		print_prompt
		echo "./a.out"
		{ ./a.out ; } 2> critical
		if [ -s critical ];
		then
			echo -n "[1;31;40m"
			echo "Segmentation fault"
			echo -n "[1;37;40m"
		fi
		rm -f critical
	fi
	rm -f a.out
}

function include_exe() {
	CC="gcc -Wall $* -o a.out"
	print_command $CC >tmp 2>&1
	print_aout >>tmp 2>&1
	IMG_COUNTER=$(( $IMG_COUNTER + 1))
	IMG_NAME=$IMG_BASE.$IMG_COUNTER.png

	cat tmp | ../enscript/ansifilter/src/ansifilter -M -o pango_test2.txt
	/home/lambret/git/ImageMagick/install/bin/convert -background black -density 150% pango:@pango_test2.txt $IMG_NAME
	./img2result.sh $IMG_NAME $IMG_NAME
	echo "![]($IMG_NAME)"
}

function include_shell() {
	print_command $* 2>&1 | fmt -72 > tmp
	IMG_COUNTER=$(( $IMG_COUNTER + 1))
	IMG_NAME=$IMG_BASE.$IMG_COUNTER.png

	cat tmp | ../enscript/ansifilter/src/ansifilter -M -o pango_test2.txt
	/home/lambret/git/ImageMagick/install/bin/convert -background black -density 150% pango:@pango_test2.txt $IMG_NAME
	./img2result.sh $IMG_NAME $IMG_NAME
	echo "![]($IMG_NAME)"
	rm -f tmp
}

cat $1 |
while read LINE
do
	if [ "${LINE:0:4}" = "@@@ " ];
	then
		CMD=${LINE:4:3}
		ARGS=${LINE:7}
		if [ "$CMD" = "inc" ];
		then
			include_c $ARGS
		elif [ "$CMD" = "sh " ];
		then
			include_shell $ARGS
		elif [ "$CMD" = "img" ];
		then
			include_src2img $ARGS
		else
			include_exe $ARGS
		fi
	else
		echo "$LINE"
	fi
done
