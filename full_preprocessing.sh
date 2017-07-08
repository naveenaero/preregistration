#!/bin/bash



#path to scripts
script=/scratch/naveen/coupling/aff_reg/preregistration
#path to preprocessed images (outputpath)
preprocessed=$3
#training data
data=$2
#path to atlas
atlas=/scratch/naveen/coupling/aff_reg/atlas/atlas_240240155_brats_norm.nii.gz
#parse patient name from command line argument
patient=$1
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
	source $script/file_preprocessing.sh norm $norm_in $norm_out
done

# Affine Registration to Jakob atlas

echo -------------------------------------------
echo //////////////////////////////////////////
echo -------------------------------------------
mod=t1
echo Affine registrating $mod to Jakob Atlas
affreg_in=${pre_norm_aff}/${patient}_${mod}.nii.gz
source ${script}/affreg.sh $atlas $affreg_in ${pre_norm_aff} 

# Transform to Atlas space
echo transforming $mod with target jakob atlas space
mod_in=$affreg_in
mod_out=${pre_norm_aff}/${patient}_${mod}.nii.gz
source ${script}/transform_modality.sh $atlas $mod_in $mod_out ${pre_norm_aff}
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
	source ${script}/transform_modality.sh $atlas $mod_in $mod_out ${pre_norm_aff}
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
source ${script}/file_preprocessing.sh histm $histm_in $atlas $histm_out






if false; then
#check N4biascorrection
for mod in t1 t2 t1ce flair
do
	n4b_in=${pre_norm_aff}/${patient}_${mod}_normaff.nii.gz
	n4b_out=${n4bias}/${patient}_${mod}_n4bias.nii.gz
	${script}/file_preprocessing.sh n4bias ${n4b_in} ${n4b_out}
	${MIRTK}/mirtk evaluate-similarity ${n4b_in} ${n4b_out} -metric CC NMI SSD -interp CSpline -threads 4 > ${n4bias}/${mod}_similarity.txt
done
fi
