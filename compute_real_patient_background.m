function [] = compute_real_patient_background(grid,label)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for j=1:length(label)
    patient = char(label(j));
    fprintf('%s\n',patient);
    cd(['/Users/naveenhimthani/Documents/Projects/brats/AA',patient,'/',num2str(grid),'_files'])
    bg = ones(grid,grid,grid);
    for i=1:9
        data = load_nii(['scan_atlas_posterior_',num2str(i),'.nii.gz']);
        bg = bg - data.img;
    end
    bg(bg>1)=1;
    bg(bg<0)=0;
    temp = load_nii('scan_atlas_posterior_1.nii.gz');
    temp.img = bg;
    save_nii(temp, ['scan_atlas_posterior_',num2str(0),'.nii.gz']);
end

end