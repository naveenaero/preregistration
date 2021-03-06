function [  ] = GenerateNCfile( filenm, data)
%GenerateNCfile creates/overwrites a classic netcdf-4 file
%   data is stored in the container 'data'
%   filenm is the path to file name without extension
%   data contains the user supplied data
if strcmp(filenm(end-2:end),'.nc')
    [nx,ny,nz] = size(data);
    varnm = 'data';
    if exist(filenm, 'file') ~=2
        % if the file doesn't exist create one!
        nccreate(filenm, varnm, 'Dimensions',{'r',nx, 'c',ny, 'h',nz},'Format','classic');
        ncwrite(filenm, varnm, data);
        fprintf('%s generated\n.........\n',filenm);
    else
        % if it already exists, overwrite it
        fprintf('file already exists!\noverwriting data\n..........\n');
        ncwrite(filenm, varnm, data);
    end
else
    % when user doesn't provide .nc extension for file name
    [nx,ny,nz] = size(data);
    filenm = [filenm, '.nc'];
    varnm = 'data';
    if exist(filenm, 'file') ~=2
        % if the file doesn't exist create one!
        nccreate(filenm, varnm, 'Dimensions',{'r',nx, 'c',ny, 'h',nz},'Format','classic');
        ncwrite(filenm, varnm, data);
        fprintf('%s generated\n.........\n',filenm);
    else
        % if it already exists, overwrite it
        fprintf('file already exists!\noverwriting data\n..........\n');
        ncwrite(filenm, varnm, data);
    end
end