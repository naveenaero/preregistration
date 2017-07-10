function [] = compute_atlas_probablity_maps( segfilenm, labelfilenm )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if segfilenm(end-3:end)=='.nii' || segfilenm(end-6:end)=='.nii.gz'
    fprintf('.nii file given\n');
    % load the segmented atlas image
    atlas_seg=load_nii(segfilenm);
    % load the probablity map for the given label
    label_map=load_nii(labelfilenm);
    
    
    
end

end

