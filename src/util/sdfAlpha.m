function [filter,t] = sdfAlpha(filterWidth, samplingRate)

C = .0001; %truncation value
a = 1/filterWidth;%sigma in samples

%find the limits of the filter. No analytical solution exists to
%this equation, so use newtons method of root finding to approximate.
b = 1/a + .1*(1/a);
e = ax(b,a);
while (e > C)
  e = ax(b,a);
  b = b - (e ./ axp (b,a));
end

t = -b:1/samplingRate:b;
s = ax(t,a);
filter = s .* (s > 0);

function f = ax(t,a)
%alpha function
f = a.^2 .* t .* exp (-a .* t);

function f = axp(t,a)
%first derivitive of alpha
f = (a^2 - a^3*t) ./ exp(a*t);
