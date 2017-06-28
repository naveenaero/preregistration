#!/bin/bash

manual=_manualCorrected.nii.gz
at=atlas
u=_
atlas=atlas_192256192.nii.gz
scan=scan_posterior_
posterior=posterior_
file=.nii.gz
THREADS=4

for label in AN MP MH QD WI XN
do
	dir=AA$label
	echo transforming $dir
	mirtk transform-image ./$dir/$dir$manual ./$dir/$dir$u$at$manual -target ./$dir/$atlas -dofin ./$dir/affine.dof -interp NN -threads $THREADS
	mirtk transform-image ./$dir/scan_label_map_1iter.nii.gz ./$dir/scan_atlas_label_map_1iter.nii.gz -target ./$dir/$atlas -dofin ./$dir/affine.dof -interp NN -threads $THREADS
	mirtk transform-image ./$dir/scan_label_map_original.nii.gz ./$dir/scan_atlas_label_map_original.nii.gz -target ./$dir/$atlas -dofin ./$dir/affine.dof -interp NN -threads $THREADS
	for num in 0 1 2 3 4 5 6 7 8 9
	do
		mirtk transform-image ./$dir/$scan$num$file ./$dir/scan_$at$u$posterior$num$file -target ./$dir/$atlas -dofin ./$dir/affine.dof -interp CSpline -threads $THREADS
	done
done


