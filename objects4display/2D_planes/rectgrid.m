function [img] = rectgrid(N,M,a,b,Dm,Dn)

if nargin < 1
    M = 2048;
end
if nargin < 2
    N = 2048;
end
if nargin < 3
    a = 32;
end
if nargin < 4
    b = 32;
end
if nargin < 5
    Dm = 0.008;
end
if nargin < 6
    Dn = 0.008;
end

fprintf('window size: %0.3f mm x %0.3f mm \n',a*Dm,b*Dn)

img = rand(N,M)/2+0.5;

for aa=1:a/4
img(b/2:b:end,0+aa:a:end) = 1;
img(b/2:b:end,a/4+aa:a:end) = 0;
img(b/2:b:end,a/2+aa:a:end) = 0;
img(b/2:b:end,a*3/4+aa:a:end) = 1;
end

for bb=1:b/4
img(0+bb:b:end,a/2:a:end) = 1;
img(a/4+bb:b:end,a/2:a:end) = 0;
img(a/2+bb:b:end,a/2:a:end) = 0;
img(a*3/4+bb:b:end,a/2:a:end) = 1;
end

end

