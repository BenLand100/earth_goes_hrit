#!/bin/bash

cd /mnt/scratch/sdr/goes_hrit_live/

LAST_FILE="last_processed"
TOTAL_VERSIONS=48
BASE_PATH="webroot"

if [ ! -f $LAST_FILE ]; then
    echo "Creating $LAST_FILE"
    touch "$LAST_FILE"
fi

MOST_RECENT_VIS=$( ls IMAGES/GOES-19/Full\ Disk/*/abi_rgb_ABI_False_Color.png | sort | tail -n3 )
MOST_RECENT_IR=$( ls IMAGES/GOES-19/Full\ Disk/*/G19_13_*.png | sort | tail -n3 )

expr='s@(.*)/[^/]+@\1@' 

MOST_RECENT_COMBO=$(comm -12 <(echo "$MOST_RECENT_VIS" | sed -Ee $expr ) <(echo "$MOST_RECENT_IR" | sed -Ee $expr ) )
MOST_RECENT_DIR=$(echo "$MOST_RECENT_COMBO" | sort | tail -n1 )

MOST_RECENT_VIS=$( echo "$MOST_RECENT_DIR"/abi_rgb_ABI_False_Color.png | tail -n1 )
MOST_RECENT_IR=$( echo "$MOST_RECENT_DIR"/G19_13_*.png | tail -n1 )

LAST_DIR=$( cat "$LAST_FILE" )
if [ "$MOST_RECENT_DIR" != "$LAST_DIR" ]; then
    echo "Rotating..."
    VUP=$TOTAL_VERSIONS
    for ((V=$VUP-1; V>=1; V--)); do
        rm -f $BASE_PATH/$VUP/*
        if [ ! -d $BASE_PATH/$VUP ]; then
            mkdir $BASE_PATH/$VUP
        fi
        if [ -d $BASE_PATH/$V ]; then
            mv $BASE_PATH/$V/* $BASE_PATH/$VUP/
        fi
        VUP=$V
    done
fi

VBP="$BASE_PATH/1/"
if [ ! -d $VBP ]; then
    mkdir $VBP
fi

echo "Processing $MOST_RECENT_DIR"

TIMESTAMP=$( echo "$MOST_RECENT_VIS" | sed -e 's@.*Full Disk/\(.*\)/abi_rgb.*@\1@' )

cp "$MOST_RECENT_VIS" "$VBP/goes_east_full_scale.png"
ln -s "goes_east_full_scale.png" "$VBP/${TIMESTAMP}_goes_east_full_scale.png"

convert "$MOST_RECENT_VIS" -background none -resize 1500x1500 -type PaletteAlpha "$VBP/goes_east_small.gif"
ln -s "goes_east_small.gif" "$VBP/${TIMESTAMP}_goes_east_small.gif"

cp "$MOST_RECENT_IR" "$VBP/${TIMESTAMP}_goes_east_ir_full_scale.png"
convert "$MOST_RECENT_IR" -background none -transparent black -resize 1500x1500 -type PaletteAlpha "$VBP/${TIMESTAMP}_goes_east_ir_small.gif"

echo "$TIMESTAMP" > "$VBP/timestamp"

echo "$MOST_RECENT_DIR" > "$LAST_FILE"
