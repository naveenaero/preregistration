#!/bin/bash

ANTSPATH=/scratch/andreas/apps/ants/build/bin
mr=$1
mt=$2
mh=$3

$ANTSPATH/ImageMath 3 $mh HistogramMatch $mt $mr
#HistogramMatch SourceImage ReferenceImage {NumberBins-Default=255} {NumberPoints-Default=64} {useThresholdAtMeanIntensity=false}
