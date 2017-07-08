#!/bin/bash

ATLAS=$1
MODALITY_IN=$2
MODALITY_OUT=$3
AFFDOFPATH=$4
THREADS=4


${MIRTK}/mirtk transform-image $MODALITY_IN $MODALITY_OUT -dofin $AFFDOFPATH/affine.dof -target $ATLAS -interp CSpline -threads $THREADS
${MIRTK}/mirtk evaluate-similarity $ATLAS $MODALITY_OUT -metric CC NMI SSD -threads $THREADS
