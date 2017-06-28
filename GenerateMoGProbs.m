function [ varargout ] = GenerateMoGProbs( filenm,flair,t1,t1ce,t2 )
%GENERATEMOGPROBS generates the probabilities for each voxel given its
%intensity in each of the modalities, based on the distributions passed in
%in filenm. The output is 9 probability map images, indexed based on the
%following classes:
%
% 1 - Background
% 2 - CSF/Ventricles
% 3 - Gray Matter
% 4 - White Matter
% 5 - Vessels
% 6 - Edema
% 7 - Necrosis/Non-Enhancing *
% 8 - Enhancing *
% 9 - Cerebellum
%
% * Unless filenm is TCwhole, in which case these probabilities are the
% same. --> TODO account for this, if needed
%
% ------ HOW TO USE -------
% 
% Assume the gmms file is located in /path/to/gmms/gmms.mat, and we have
% already loaded flair,t1,t1ce,t2 (through ReadBratsBrain or
% ReadPennBrain). Then finding the probability maps for edema would go as
% follows:
%
% 1. [p1,p2,p3,p4,p5,p6,p7,p8,p9] =
%       GenerateMoGProbs('/path/to/gmms/gmms.mat',flair,t1,t1ce,t2);
% 2.load('/path/to/gmms/gmms.mat');
%   [p1,p2,p3,p4,p5,p6,p7,p8,p9] =
%       GenerateMoGProbs(gmms,flair,t1,t1ce,t2);
% 
% Then edema is p6. 

% Make into a matrix that can be called by fitgmdist obj
mods = 4;
GF = zeros(numel(flair),mods);
GF(:,1) = flair(:); 
GF(:,2) = t1(:);
GF(:,3) = t1ce(:);
GF(:,4) = t2(:);

% load gmm file
if isa(filenm,'char')
    fdir = fileparts(filenm);
    addpath(fdir);
    load(filenm); % should produce gmms
else
    gmms = filenm; % gmms are passed in
end

cc = length(gmms);
varargout = cell(1,cc);
cprobs = zeros(numel(flair),cc);

for ci = 1:cc
    % Get pdf vector for cur class
    cprobs(:,ci) = gmms{ci}.pdf(GF);
end

sumC = sum(cprobs,2) + eps; % don't divide by zero
cprobs = bsxfun(@rdivide,cprobs,sumC);

% Load into varargout
for ci = 1:cc
    varargout{ci} = reshape(cprobs(:,ci),size(flair));
end

end

