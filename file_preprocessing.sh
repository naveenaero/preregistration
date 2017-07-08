#!/bin/bash


if [ "$1" == "norm" ]; then
	outputImage=$3
	inputImage=$2
	${ANTS}/ImageMath 3 $outputImage Normalize $inputImage
fi

if [ "$1" == "histm" ]; then
	sourceImage=$2
	referenceImage=$3 #atlas
	outputImage=$4
	${ANTS}/ImageMath 3 $outputImage HistogramMatch $sourceImage $referenceImage 128 #{NumberBins-Default=255} {NumberPoints-Default=64} {useThresholdAtMeanIntensity=false}
fi

if [ "$1" == "n4bias" ]; then
	inputImage=$2
	outputImage=$3
	${ANTS}/N4BiasFieldCorrection -d 3 -c [2x2x2x2,0] -b [200] -s 2 -i $inputImage -o $outputImage
fi
