function [filter,x] = sdfGaussian(filterWidth, samplingRate)

C=.0001;%truncation level
c = filterWidth;
a = 1 / (c*sqrt(2*pi));
x = -2^(1/2)*c*(-log(C/a))^(1/2) : 1 / samplingRate : 2^(1/2)*c*(-log(C/a))^(1/2);
filter = a .* exp( -1 .* (x.^2 ./ (2*c^2)) );