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

# Send D-Bus message to notify the user
dbus-send --type=method_call --dest=org.freedesktop.Notifications \
          /org/freedesktop/Notifications \
          org.freedesktop.Notifications.Notify \
          string:"ScrOCR" uint32:1 \
          string:"" \
          string:"OCR Completed" \
          string:"Selected area has been converted to text by OCR and dumped to your clipboard." \
          array:string:"" \
          dict:string:string:"","" int32:5000

exit
