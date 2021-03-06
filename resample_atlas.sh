#!/bin/bash

dir=./segmented_atlas/atlas_256_seg
cd $dir
niiext=.nii
oldgrid=256256128
newgrid=256
uscore=_
jakob=jakob
atlas=atlas
threads=4

for label in csf vt
do
oldfile=$jakob$uscore$label$uscore$oldgrid$niiext
newfile=$atlas$uscore$newgrid$uscore$label$niiext
mirtk resample-image $oldfile $newfile -interp NN -imsize $newgrid $newgrid $newgrid -threads $threads
done
