#! /bin/bash

DARK_BG=SteelBlue4
LIGHT_BG=lavender
ALPHA_BG=#33445500
BORDER_SIZE=1
MARGIN=5
WIDTH=450
FONT=Courier
FONTSIZE=16

function label() {
	LABEL=$1
	FILENAME=$2

	convert -background $DARK_BG -fill $LIGHT_BG -font $FONT -size ${WIDTH}x$(($FONTSIZE * 2))  -pointsize $FONTSIZE  -gravity center label:$LABEL $FILENAME
}

function code2img() {
	SOURCE=$1
	FILENAME=$2
	enscript --file-align=1 --color -f $FONT$FONTSIZE -1 -B --highlight=c -h --margins=0:0:0:0 $SOURCE -o - |
	convert - -trim -bordercolor $LIGHT_BG -border $MARGIN $FILENAME
}

function src2img() {
	SOURCE=$1
	TITLE=$SOURCE.label.png
	CODE=$SOURCE.code.png
	RESULT=$2
	label $SOURCE $TITLE
	code2img $SOURCE $CODE
	convert -background $LIGHT_BG -append $TITLE $CODE -flatten $RESULT
	rm -f $TITLE $CODE
}

function create_column() {
	if [ "$LIST" != "" ]
	then
		COLUMN_COUNTER=$(( $COLUMN_COUNTER + 1))
		convert -background $ALPHA_BG -append $LIST -bordercolor $DARK_BG -border $BORDER_SIZE -bordercolor $ALPHA_BG -border 0x$MARGIN $I.$COLUMN_COUNTER.png
		rm -f $LIST
		COLUMN_IMGS="$COLUMN_IMGS $I.$COLUMN_COUNTER.png" 
	fi
}

COUNT=0
COLUMN_COUNTER=0
COLUMN_IMGS=
LIST=
LEFT=
RIGHT=
# XXX : Bash trick to find the last parameter
for RESULT_IMG in $*
do
	true
done

for I in $*;
do
	COUNT=$(($COUNT +1))
	if [ $COUNT -eq $# ]
	then
		create_column
		convert -background $ALPHA_BG +append $COLUMN_IMGS -bordercolor $ALPHA_BG -border $MARGIN $I
		rm -f $COLUMN_IMGS
	elif [ "$I" = ":" -a "$LIST" != "" ]
	then
		create_column
		LIST=
	else
		src2img $I $I.png
		LIST="$LIST $I.png"
	fi
done
