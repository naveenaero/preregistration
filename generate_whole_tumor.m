function [] = generate_whole_tumor(tum_label_num,grid)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

tu = zeros(grid,grid,grid);
for i=1:length(tum_label_num)
    label_num = tum_label_num(i);
    data = load_nii(['scan_atlas_posterior_',str2double(label_num),'.nii.gz']);
    tu = tu + data.img;
end
tu(tu>1)=1;
tu(tu<0)=0;
temp = load_nii('scan_atlas_posterior_1.nii.gz');
temp.img = temp.img*0 + tu;
save_nii(temp, 'scan_atlas_posterior_10.nii.gz');
end

