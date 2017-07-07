#!/bin/bash

script=/scratch/naveen/coupling/aff_reg/preregistration
preprocessed=/org/groups/padas/lula_data/medical_images/brain/BRATS17/preprocessed
#training data
data=/org/groups/padas/lula_data/medical_images/brain/BRATS17/trainingdata/HGG
atlas=/scratch/naveen/coupling/aff_reg/atlas/atlas_240240155_brats_norm.nii.gz
patient=$1
preppatient=$preprocessed/$patient
# create directory for new pre-processed patient
# do it separately for norm-aff and norm-aff-hist
preaffnorm=pre-aff-norm
mkdir -p ${preprocessed}/$preaffnorm
preaffnormhist=pre-aff-norm-hist
mkdir -p ${preprocessed}/$preaffnormhist



uscore=_
ext=.nii.gz
norm=norm
histm=histm
n4bias=n4bias
affreg=affreg2atlas

for mod in t1 t2 t1ce flair
do
	#normalization
	echo normalization for $mod
	norm_in=$data/$patient/${patient}_${mod}.nii.gz
	norm_out=$prepatient/${patient}_${mod}.nii.gz
	source ${script}/file_preprocessing.sh norm $norm_in $norm_out
	
	if false
	then

	if [ "$mod" == "t1" ]; then
		# Histogram Matching for t1
		echo Histogram Matching for $mod
		histm_in=$norm_out
		histm_out=$norm_out
		source ${script}/file_preprocessing.sh histm $histm_in $atlas $histm_out
	fi
	fi
done

# Affine Registration to Jakob atlas
mod=t1
echo Affine registration for $mod
affreg_in=$preppatient/${patient}_${mod}.nii.gz
source ${script}/affreg.sh $atlas $affreg_in $affreg2atlas 

# Transform to Atlas space
echo transforming $mod with target atlas space
mod_in=$affreg_in
mod_out=$affreg2atlas/$patient$uscore$mod$uscore$n4bias$uscore$norm$uscore$histm$uscore$affreg$ext
source ${script}/transform_modality.sh $atlas $mod_in $mod_out $affreg2atlas

# Transform other modalities
for mod in t2 t1ce flair
do	
	echo transforming $mod with target atlas space
	mod_in=$normalized/$patient$uscore$mod$uscore$n4bias$uscore$norm$ext
	mod_out=$affreg2atlas/$patient$uscore$mod$uscore$n4bias$uscore$norm$uscore$affreg$ext
	source ${script}/transform_modality.sh $atlas $mod_in $mod_out $affreg2atlas
done
