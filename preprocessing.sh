#!/bin/bash

export ANTS=/scratch/andreas/apps/ants/build/bin
export MIRTK=/scratch/andreas/apps/mirtk/build/bin

file_preprocessing ()
# processes a single file and does one of the following
# norm - Normalization
# histm - Histogram Matching
# n4bias - N4 Bias Correction
# $1 is one of the above three arguments
# $2 is the input/source(Histogram) file 
# $3 is the output image
# $4 is the reference image for Histogram Matching
{
	if [ "$1" == "norm" ]; then
	inputImage=$2
	outputImage=$3
	${ANTS}/ImageMath 3 $outputImage Normalize $inputImage
	fi

	if [ "$1" == "histm" ]; then
	sourceImage=$2
	outputImage=$3
	referenceImage=$4 #atlas
	${ANTS}/ImageMath 3 $outputImage HistogramMatch $sourceImage $referenceImage 128
	fi

	if [ "$1" == "n4bias" ]; then
	inputImage=$2
	outputImage=$3
	${ANTS}/N4BiasFieldCorrection -d 3 -c [2x2x2x2,0] -b [200] -s 2 -i $inputImage -o $outputImage
	fi
}

affreg ()
# $1 is path to atlas image
# $2 is the input modality image
# $3 is the path to which the affine.dof is to be written
{
	ATLAS=$1
	MODALITY=$2
	AFFDOFPATH=$3
	THREADS=4

	#### Register modality(T1)  to Jacob Atlas
	${MIRTK}/mirtk register $ATLAS $MODALITY -model Affine -dofout $AFFDOFPATH/affine.dof -threads $THREADS
}

transform_modality ()
# $1 is path to atlas image
# $2 is the input modality image
# $3 is the output modality image
# $4 is the path to which the affine.dof is to be written
{
	ATLAS=$1
	MODALITY_IN=$2
	MODALITY_OUT=$3
	AFFDOFPATH=$4
	THREADS=4


	${MIRTK}/mirtk transform-image $MODALITY_IN $MODALITY_OUT -dofin $AFFDOFPATH/affine.dof -target $ATLAS -interp CSpline -threads $THREADS
	${MIRTK}/mirtk evaluate-similarity $ATLAS $MODALITY_OUT -metric CC NMI SSD -threads $THREADS
}

patient_preprocessing()
# NOTE: this function is hardcoded to handle input patient files of the type ${patient}_${mod}.nii.gz where ${patient} is the name of the directory containing input image modalities(${mod}) i.e. t1,t2,t1ce,flair
# $1 is the name in string format of the patient directory which contains all the input modality images
# $2 is the path to input data
# $3 is the path to output data (preprocessed data)
# $4 is the path to atlas file (should be normalized)
{
	#parse patient name from command line argument
	patient=$1
	#training data
	data=$2
	#path to preprocessed images (outputpath)
	preprocessed=$3
	#path to atlas
	atlas=$4

	echo -------------------------------------------
	echo Preprocessing $patient 
	echo -------------------------------------------
	# create directory for new pre-processed patient
	# do it separately for norm-aff and norm-aff-hist

	#n4bias=$preprocessed/N4BiasCorrection/$patient
	#mkdir -p ${n4bias}
	pre_norm_aff=$preprocessed/pre-norm-aff/$patient
	mkdir -p ${pre_norm_aff}
	pre_norm_aff_hist=$preprocessed/pre-norm-aff-hist/$patient
	mkdir -p ${pre_norm_aff_hist}

	echo //////////////////////////////////////////
	echo -------------------------------------------

	for mod in t1 t2 t1ce flair
	do
		#normalization
		echo normalization modality $mod
		norm_in=$data/$patient/${patient}_${mod}.nii.gz
		norm_out=${pre_norm_aff}/${patient}_${mod}.nii.gz
		file_preprocessing norm $norm_in $norm_out
	done

	# Affine Registration to Jakob atlas

	echo -------------------------------------------
	echo //////////////////////////////////////////
	echo -------------------------------------------
	mod=t1
	echo Affine registrating $mod to Jakob Atlas
	affreg_in=${pre_norm_aff}/${patient}_${mod}.nii.gz
	affreg $atlas $affreg_in ${pre_norm_aff} 

	# Transform to Atlas space
	echo transforming $mod with target jakob atlas space
	mod_in=$affreg_in
	mod_out=${pre_norm_aff}/${patient}_${mod}.nii.gz
	transform_modality $atlas $mod_in $mod_out ${pre_norm_aff}
	mv $mod_out ${pre_norm_aff}/${patient}_${mod}_normaff.nii.gz
	echo -------------------------------------------
	echo //////////////////////////////////////////
	echo -------------------------------------------
	# Transform other modalities
	for mod in t2 t1ce flair
	do	
		echo transforming $mod with target atlas space
		mod_in=${pre_norm_aff}/${patient}_${mod}.nii.gz
		mod_out=${pre_norm_aff}/${patient}_${mod}.nii.gz
		transform_modality $atlas $mod_in $mod_out ${pre_norm_aff}
		mv $mod_out ${pre_norm_aff}/${patient}_${mod}_normaff.nii.gz
	done
	echo -------------------------------------------

	# histogram matching for t1 and storing in separate folder
	mod=t1
	echo ----------------------------
	echo Histogram Matching for $mod
	echo ----------------------------
	histm_in=${pre_norm_aff}/${patient}_${mod}_normaff.nii.gz
	histm_out=${pre_norm_aff_hist}/${patient}_${mod}_normaff_histm.nii.gz
	file_preprocessing histm $histm_in $histm_out $atlas


	# #check N4biascorrection
	# for mod in t1 t2 t1ce flair
	# do
	# 	n4b_in=${pre_norm_aff}/${patient}_${mod}_normaff.nii.gz
	# 	n4b_out=${n4bias}/${patient}_${mod}_n4bias.nii.gz
	# 	${script}/file_preprocessing.sh n4bias ${n4b_in} ${n4b_out}
	# 	${MIRTK}/mirtk evaluate-similarity ${n4b_in} ${n4b_out} -metric CC NMI SSD -interp CSpline -threads 4 > ${n4bias}/${mod}_similarity.txt
	# done
	# fi
}

datapath=/org/groups/padas/lula_data/medical_images/brain/BRATS17/Brats17ValidationData
outputpath=/org/groups/padas/lula_data/medical_images/brain/BRATS17/preprocessed/validationdata
atlas=/scratch/naveen/coupling/aff_reg/atlas/atlas_240240155_brats_norm.nii.gz
for path in ${datapath}/Brats*; do
    [ -d "${path}" ] || continue # if not a directory, skip
    dirname="$(basename "${path}")"
    patient_preprocessing $dirname $datapath $outputpath $atlas
done
