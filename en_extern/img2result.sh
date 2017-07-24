#! /bin/bash

DARK_BG=SteelBlue4
LIGHT_BG=lavender
ALPHA_BG=#33445500
BORDER_SIZE=1
MARGIN=5
WIDTH=912
FONT=Courier
FONTSIZE=16

function label() {
	LABEL=$1
	FILENAME=$2

	convert -background $DARK_BG -fill $LIGHT_BG -font $FONT -size ${WIDTH}x$(($FONTSIZE * 2))  -pointsize $FONTSIZE  -gravity center label:$LABEL $FILENAME
}

label Result result.png
convert -background black -bordercolor $ALPHA_BG -border $MARGIN $2 $2
convert -background black -append result.png $1 -flatten $2
convert -background $ALPHA_BG -bordercolor $DARK_BG -border 1 $2 $2
convert -background $ALPHA_BG -bordercolor $ALPHA_BG -border $MARGIN $2 $2
rm -f result.png
