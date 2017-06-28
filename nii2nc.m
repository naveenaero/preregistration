function [] = nii2nc(filenm)

if filenm(end-3:end)=='.nii'
    image = load_nii(filenm);
    imgarr = image.img;
    newfilenm=filenm(1:end-4);
    GenerateNCfile(newfilenm, imgarr);
else
    fprintf('Provide .nii file only. exiting\n');
end
end
