#!/bin/bash
# DEPENDENCIES: tesseract-ocr scrot imagemagick xsel
# AUTHOR:       *LycanDarko
# NAME:         ScrOCR

# tesseract requires the locale to be set, modify this line if you have a different locale
export LC_ALL=en_US.UTF-8

# Set language here, default is english
LANG="eng"

SCR_IMG=$(mktemp)
trap "rm $SCR_IMG*" EXIT

scrot -s "$SCR_IMG".png -q 100 #take screenshot of area
mogrify -modulate 100,0 -resize 400% "$SCR_IMG".png # postprocess to prepare for OCR

tesseract -l "$LANG" "$SCR_IMG".png stdout | xsel -bi

exit
