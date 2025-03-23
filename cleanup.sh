#!/bin/bash

cd /mnt/scratch/sdr/goes_hrit_live/

find EMWIN -mmin +60 -delete -print
find IMAGES L2 -mmin +120 -type f \
    ! -name '*abi_rgb_ABI_False_Color.png' \
    ! -name '*G16_15_*.png' \
    ! -name '*G16_13_*.png' \
    ! -name '*G18_13_*.png' \
    -delete -print



