function [ ] = smooth_brain( filenm, sigma, newext )
% filenm - path to .nii/.nc file
% sigma - gaussian filter smoothing kernel standard deviation
% output - new .nii/.nc file with smoothed data
if filenm(end-3:end)=='.nii'
    oldimage = load_nii(filenm);
    newimage = imgaussfilt3(oldimage.img,sigma);
    newfilenm=[filenm(1:end-4),'_sigma',num2str(sigma),newext];
    if newext=='.nii' || newext=='.nii.gz'
        newimage = make_nii(newimage);
        save_nii(newimage, newfilenm);
    elseif newext=='.nc'
        GenerateNCfile(newfilenm,newimage);
    end

elseif filenm(end-6:end)=='.nii.gz'
    oldimage = load_nii(filenm);
    newimage = imgaussfilt3(oldimage.img,sigma);
    newfilenm=[filenm(1:end-7),'_sigma',num2str(sigma),newext];
    if strcmp(newext,'.nii') || strcmp(newext,'.nii.gz')
        newimage = make_nii(newimage);
        save_nii(newimage, newfilenm);
    elseif strcmp(newext,'.nc')
        GenerateNCfile(newfilenm,newimage);
    end


elseif filenm(end-2:end)=='.nc'
    oldimage = ncread(filenm, 'data');
    newimage = imgaussfilt3(oldimage,sigma);
    newfilenm=[filenm(1:end-3),'_sigma',num2str(sigma),newext];
    if newext=='.nii' || newext=='.nii.gz'
        newimage = make_nii(newimage);
        save_nii(newimage, newfilenm);
    elseif newext=='.nc'
        GenerateNCfile(newfilenm,newimage);
    end
    
else
    fprintf('please give either .nii or .nii.gz or .nc file. exiting!');
    return;
end
end


