function [ ] = smooth_brain( filenm, sigma )
% filenm - path to .nii/.nc file
% sigma - gaussian filter smoothing kernel standard deviation
% output - new .nii/.nc file with smoothed data
if filenm(end-3:end)=='.nii'
    oldimage = load_nii(filenm);
    newimage = imgaussfilt3(oldimage.img,sigma);
    newimage = make_nii(newimage);
    save_nii(newimage, ['smooth_',filenm]);

elseif filenm(end-2:end)=='.nc'
    oldimage = ncread(filenm, 'data');
    newimage = imgaussfilt3(oldimage,sigma);
    GenerateNCfile(['smooth_',filenm(1:end-3)], newimage);
else
    fprintf('please give either .nii or .nc file. exiting!');
    return;
end
end


