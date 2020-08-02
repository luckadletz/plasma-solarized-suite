#!/bin/bash
# Installs a fortune to the system

TARGET=$1 # Fortunes should be in text files, without extensions, delimeted by %
FORTUNE_DIR=/usr/share/games/fortunes/
DAT=${TARGET}.dat

echo $TARGET "->" $DAT "->" $FORTUNE

strfile $TARGET $DAT
sudo cp $TARGET $DAT $FORTUNE_DIR
rm $DAT