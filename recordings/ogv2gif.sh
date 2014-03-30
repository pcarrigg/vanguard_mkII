#!/usr/bin/env bash

# input checks, arg must be an ogv file-name
if [[ -z $1 || ! -f $1 ]]; then
	echo "Usage: $0 <ogv file>";
	exit 1;
fi

DIRS="jpg"
base=`basename $1 .ogv`

# make sure some temp dirs are available and empty
for d in $DIRS; do
	mkdir -p ./tmp/$d
	rm -r ./tmp/$d/* 2>/dev/null
done
rm -r ./tmp/* 2>/dev/null

mplayer -ao null $1 -vo jpeg:outdir=./tmp/jpg
echo "converting jpegs to animated gif ..."
convert ./tmp/jpg/* ./tmp/$base.gif
echo "optimizing gif ..."
convert ./tmp/$base.gif -fuzz 5% -layers OptimizePlus $base.gif
convert ./tmp/$base.gif -resize 400 -fuzz 5% -layers Optimize $base-400-optimized.gif
convert ./tmp/$base.gif -resize 600 -fuzz 5% -layers Optimize $base-600-optimized.gif
convert ./tmp/$base.gif -resize 800 -fuzz 5% -layers Optimize $base-800-optimized.gif

