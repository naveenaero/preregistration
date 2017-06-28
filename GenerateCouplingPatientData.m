clear;
clc;

numpatients = 1:8;
patientdir = 'patient';
%adding path might create problems
%addpath('/h2/naveen/brats17/matlab/prior');
% addpath('~/Documents/Softwares/MATLAB/NIFTI');

brn = 'AAAC'; % choose which brain to base probs on
kk = 1; % num ber of gaussians to mix per class
tol = 0.99; % determines which points to use to fit distribution
TCflag = true; % Process whole tumor core together? T or F
% pathtofile = '/org/groups/padas/lula_data/medical_images/brain/probPennData/pennModels/';
% filenm = [pathtofile,brn,'_k',num2str(kk),'_p',num2str(tol)];
fileNM = [brn,'_k',num2str(kk),'_p',num2str(tol)];
if TCflag
                fileNM = [fileNM,'_TCwhole.mat'];
else
                fileNM = [fileNM,'.mat'];
end

for i=1:length(numpatients)
    

    %% Load synthetic tumor images
    fprintf('\nLoading synthetic tumour MRI images for patient %d.....Please wait\n',numpatients(i));
    testcase = i;
%     pathtosyntheticimages = ['/scratch/data/brats/syntheticImages/testcase',num2str(testcase),'/additional/images.mat'];
%     load(pathtosyntheticimages);
    pathtoimages = ['./',patientdir,num2str(numpatients(i)),'/'];
    t1 = load_nii([pathtoimages,'t1_atlas.nii.gz']);
    t2 = load_nii([pathtoimages,'t2_atlas.nii.gz']);
    t1ce = load_nii([pathtoimages,'t1ce_atlas.nii.gz']);
    flair = load_nii([pathtoimages,'flair_atlas.nii.gz']);
    t1=t1.img; t2=t2.img; t1ce=t1ce.img; flair=flair.img;
    
    
    %% Generate probability maps from synthetic tumor images
    fprintf('\n\nGenerating probability maps from synthetic MRI images.....Please wait\n')
    
    [ p1,p2,p3,p4,~,p6,p7,p8,~] = GenerateMoGProbs(fileNM,flair,t1,t1ce,t2 );
    % 1 - Background - bg
    % 2 - CSF/Ventricles - csf
    % 3 - Gray Matter - gm
    % 4 - White Matter - wm
    % 5 - Vessels
    % 6 - Edema - tu/glm
    % 7 - Necrosis/Non-Enhancing * - tu/glm
    % 8 - Enhancing * - tu/glm
    % 9 - Cerebellum
    fprintf('Probabilty maps generated\n');
    
    %% generate .nc files for labels
    GenerateLabelfiles(p1,p2,p3,p4,p6,p7,p8,numpatients(i),pathtoimages);
    
end