#!/bin/bash

ATLAS=$1
MODALITY=$2
AFFDOFPATH=$3
THREADS=4

#### Register modality(T1)  to Jacob Atlas
${MIRTK}/mirtk register $ATLAS $MODALITY -model Affine -dofout $AFFDOFPATH/affine.dof -threads $THREADS
