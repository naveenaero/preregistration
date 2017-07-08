#!/bin/bash

CASE=patientx
THREADS=4

if [[ ${CASE:0:2} == 'AA' ]]
then
	ATLAS=atlas_192256192.nii.gz
	AT=_atlas
	T1=_t1_pp.nii.gz
	T2=_t2_pp.nii.gz
	T1CE=_t1ce_pp.nii.gz
	FLAIR=_flair_pp.nii.gz
	T1_ATLAS=$AT$T1
	T2_ATLAS=$AT$T2
	T1CE_ATLAS=$AT$T1CE
	FLAIR_ATLAS=$AT$FLAIR
	#### Register T1 to Jacob Atlas, transform and evaluate similarity
	mirtk register $ATLAS $CASE$T1 -model Affine -dofout affine.dof -threads $THREADS
	mirtk transform-image $CASE$T1 $CASE$T1_ATLAS -dofin affine.dof -target $ATLAS -threads $THREADS
	mirtk evaluate-similarity $ATLAS $CASE$T1_ATLAS -metric CC NMI SSD -threads $THREADS
	##### transform other modalities
	mirtk transform-image $CASE$FLAIR $CASE$FLAIR_ATLAS -dofin affine.dof -target $ATLAS -threads $THREADS
	mirtk transform-image $CASE$T1CE $CASE$T1CE_ATLAS -dofin affine.dof -target $ATLAS -threads $THREADS
	mirtk transform-image $CASE$T2 $CASE$T2_ATLAS -dofin affine.dof -target $ATLAS -threads $THREADS
else
	echo Registering for $CASE
	ATLAS=atlas_256.nii.gz
	#### Register T1 to Jacob Atlas, transform and evaluate similarity
	mirtk register $ATLAS t1.nii -model Affine -dofout affine.dof -threads $THREADS
	mirtk transform-image t1.nii t1_atlas.nii.gz -dofin affine.dof -interp CSpline -target $ATLAS
	mirtk evaluate-similarity $ATLAS t1_atlas.nii.gz -metric CC NMI SSD

	##### transform other modalities
	mirtk transform-image t2.nii t2_atlas.nii.gz -dofin affine.dof -interp CSpline -target $ATLAS
	mirtk transform-image t1ce.nii t1ce_atlas.nii.gz -dofin affine.dof -interp CSpline -target $ATLAS
	mirtk transform-image flair.nii flair_atlas.nii.gz -dofin affine.dof -interp CSpline -target $ATLAS
fi
