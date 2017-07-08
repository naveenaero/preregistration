#!/bin/bash

datapath=/org/groups/padas/lula_data/medical_images/brain/BRATS17/Brats17ValidationData
outputpath=/org/groups/padas/lula_data/medical_images/brain/BRATS17/preprocessed/validationdata
script=/scratch/naveen/coupling/aff_reg/preregistration/
for path in ${datapath}/Brats*; do
    [ -d "${path}" ] || continue # if not a directory, skip
    dirname="$(basename "${path}")"
    ${script}/full_preprocessing.sh $dirname $datapath $outputpath
done
