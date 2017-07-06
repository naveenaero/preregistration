function [] = compute_jakob_atlas_background(grid)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


csf_vt = load_nii(['atlas_',num2str(grid),'_csf_vt.nii']);
wm = load_nii(['atlas_',num2str(grid),'_wm.nii']);
gm = load_nii(['atlas_',num2str(grid),'_gm.nii']);
cb = load_nii(['atlas_',num2str(grid),'_cb.nii']);
bg = 1 - csf_vt.img - wm.img - gm.img - cb.img;
bg = make_nii(bg);
save_nii(bg, ['atlas_',num2str(grid),'_bg.nii']);

end

