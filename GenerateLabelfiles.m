function [] = GenerateLabelfiles( p1,p2,p3,p4,p6,p7,p8,i,pathtoimages )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Generate .nc files

%     basicfilenm = 'patient_';
%     basicfilenm = [basicfilenm, num2str(n(1))];
% 
%     newfolder = ['testcase',num2str(testcase)];
%     if exist(newfolder, 'dir')~=7
%         mkdir(newfolder);
%         basicfilenm = ['./',newfolder,'/',basicfilenm];
%     else
%         basicfilenm = ['./',newfolder,'/',basicfilenm];
%     end
    
fprintf('\nGenerating .nc files\n');
basicfilenm = [pathtoimages,'patient',num2str(i)];

filenm = [basicfilenm, '_', 'bg'];
GenerateNCfile(filenm, p1);

filenm = [basicfilenm, '_', 'csf'];
GenerateNCfile(filenm, p2);

filenm = [basicfilenm, '_', 'gm'];
GenerateNCfile(filenm, p3);

filenm = [basicfilenm, '_', 'wm'];
GenerateNCfile(filenm, p4);

filenm = [basicfilenm, '_', 'edm'];
GenerateNCfile(filenm, p6);

filenm = [basicfilenm, '_', 'nec'];
GenerateNCfile(filenm, p7);

filenm = [basicfilenm, '_', 'enh'];
GenerateNCfile(filenm, p8);

filenm = [basicfilenm, '_', 'glm'];
GenerateNCfile(filenm, p6+p7+p8);

fprintf('.nc files generated\n\nDONE\n');

end


