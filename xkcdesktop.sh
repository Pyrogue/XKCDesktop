#!/bin/bash
#----------------
#Description:	Loads the image from the xkcd homepage
#			Intended to be used as a startup application
#Author:		Pyrogue
#Github:		https://github.com/Pyrogue/xkcdesktop.git
#Credits:		xkcd.com
#----------------
KEY="Image URL (for hotlinking/embedding): "
URL="xkcd.com"
DIR="/tmp"
HTML="xkcd.html"
PIC="xkcd.png"

echo "--------------------------"
echo "Changing Working Directory"
cd $DIR

echo "---------------------"
echo "Cleaning directory..."
rm "$HTML"
rm "$PIC"

echo "-------------------"
echo "Checking Connection"
while ! ping -c 1 -W 1 xkcd.com; do
    echo "Waiting for xkcd.com - network interface might be down..."
    sleep 5
done

echo "------------------"
echo "Getting webpage..."
wget -O $HTML $URL -nv

echo "--------------------------"
echo "Parsing for hotlink url..."
URL=$(grep "$KEY" "$HTML")
URL=${URL:${#KEY}}

echo "----------------"
echo "Getting Image..."
wget -O $PIC $URL -nv

#install "imagemagick" to negate
echo "Checking for existance of imagemagick"
if hash convert 2>/dev/null; then
	echo "--------------------"
	echo "Developing Negatives"
	convert -negate $PIC $PIC
else
	echo >&2 "Attempting to negate image, but lacking package:"
	echo >&2 "\"convert\" from \"imagemagick\""
	echo >&2 "run: \"sudo apt-get install imagemagick\" to install";
fi

echo "-----------------"
echo "Setting Wallpaper"
gsettings set org.gnome.desktop.background picture-uri "file://$DIR/$PIC"
gsettings set org.gnome.desktop.background picture-options "centered"
