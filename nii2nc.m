function [] = nii2nc(filenm)
% needs the NIFTI matlab module to be present in the path
% filenm - path to .nii file
% output - .nc file of same name

if filenm(end-3:end)=='.nii'
    image = load_nii(filenm);
    imgarr = image.img;
    newfilenm=filenm(1:end-4);
    GenerateNCfile(newfilenm, imgarr);
elseif filenm(end-6:end)=='.nii.gz'
    image = load_nii(filenm);
    imgarr = image.img;
    newfilenm=filenm(1:end-7);
    GenerateNCfile(newfilenm, imgarr);
else
    fprintf('Provide .nii or .nii.gz file only. exiting\n');
end
end
