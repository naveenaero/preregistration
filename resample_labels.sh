#!/bin/bash

ext=.nii.gz
for label in MP MH QD WI XN
do
cd AA$label
echo in AA$label
mkdir 256_files
mirtk resample-image scan_atlas_label_map_1iter.nii.gz 256_files/scan_atlas_label_map_1iter.nii.gz -interp NN -imsize 256 256 256 -threads 4
mirtk resample-image scan_atlas_label_map_original.nii.gz 256_files/scan_atlas_label_map_original.nii.gz -interp NN -imsize 256 256 256 -threads 4
for num in 0 1 2 3 4 5 6 7 8 9
do
mirtk resample-image scan_atlas_posterior_$num$ext 256_files/scan_atlas_posterior_$num$ext -interp NN -imsize 256 256 256 -threads 4
done
cd ..
done
