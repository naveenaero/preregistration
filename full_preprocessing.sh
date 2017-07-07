#!/bin/bash

#path to scripts
script=/scratch/naveen/coupling/aff_reg/preregistration
#path to preprocessed images
preprocessed=/org/groups/padas/lula_data/medical_images/brain/BRATS17/preprocessed
#training data
data=/org/groups/padas/lula_data/medical_images/brain/BRATS17/trainingdata/HGG
#path to atlas
atlas=/scratch/naveen/coupling/aff_reg/atlas/atlas_240240155_brats_norm.nii.gz
#parse patient name from command line argument
patient=$1

# create directory for new pre-processed patient
# do it separately for norm-aff and norm-aff-hist
pre-norm-aff=$preprocessed/pre-norm-aff/$patient
mkdir -p $pre-norm-aff
pre-norm-aff-hist=$preprocessed/pre-norm-aff-hist/$patient
mkdir -p $pre-norm-aff-hist

# norm=norm
# histm=histm
# n4bias=n4bias
# affreg=affreg2atlas

for mod in t1 t2 t1ce flair
do
	#normalization
	echo normalization for $mod
	norm_in=$data/$patient/${patient}_${mod}.nii.gz
	norm_out=$pre-norm-aff/${patient}_${mod}.nii.gz
	source $script/file_preprocessing.sh norm $norm_in $norm_out
done

# Affine Registration to Jakob atlas
mod=t1
echo Affine registration for $mod
affreg_in=$pre-norm-aff/${patient}_${mod}.nii.gz
source ${script}/affreg.sh $atlas $affreg_in $pre-norm-aff 

# Transform to Atlas space
echo transforming $mod with target atlas space
mod_in=$affreg_in
mod_out=$pre-norm-aff/${patient}_${mod}_normaff.nii.gz
source ${script}/transform_modality.sh $atlas $mod_in $mod_out $pre-norm-aff

# Transform other modalities
for mod in t2 t1ce flair
do	
	echo transforming $mod with target atlas space
	mod_in=$pre-norm-aff/${patient}_${mod}.nii.gz
	mod_out=$pre-norm-aff/${patient}_${mod}_normaff.nii.gz
	source ${script}/transform_modality.sh $atlas $mod_in $mod_out $pre-norm-aff
done


# histogram matching for t1 and storing in separate folder
mod=t1
echo Histogram Matching for $mod
histm_in=$pre-norm-aff/${patient}_${mod}_normaff.nii.gz
histm_out=$pre-norm-aff-hist/${patient}_${mod}_normaff_histm.nii.gz
source ${script}/file_preprocessing.sh histm $histm_in $atlas $histm_out


