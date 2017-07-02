function [ COM ] = remove_tumor_noise( filenm )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

data = ncread(filenm,'data');
radius = 50; % mm
[X,Y,Z] = ndgrid(0:1.875:240-1.875, 0:1.875:240-1.875, 0:1.5:192-1.5);
denom = sum(data(:));
numX = X.*data;
numY = Y.*data;
numZ = Z.*data;
COM = [sum(numX(:)); sum(numY(:)); sum(numZ(:))]/denom;
dist = ((X-COM(1)).^2 + (Y-COM(2)).^2 + (Z-COM(3)).^2).^0.5;
outside = (dist>radius);
data(outside)=0;
data(data<0.3)=0;
GenerateNCfile('filtered_glm',data);


end

