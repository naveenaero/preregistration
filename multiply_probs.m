function [ ] = multiply_probs(filenm1, filenm2, newfilenm)

data1 = ncread(filenm1,'data');
data2 = ncread(filenm2,'data');
%multiply
newdata = data1.*data2;
%rescale
newdata(newdata>1)=1;
newdata(newdata<0)=0;
%create new .nc file
GenerateNCfile(newfilenm, newdata);

end

