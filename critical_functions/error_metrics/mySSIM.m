function [ssimerror,ssimmap] = mySSIM(I,I0)
%compute local SSIM erros
% I0=scaleValues(I0,0,1); I=scaleValues(I,0,1);
c1=0.01^2; c2=0.03^2;
radius = 1.5; filtSize = ceil(radius*3)*2+1;
gaussFilterFcn = @(X)imgaussfilt(X, radius, 'FilterSize', filtSize, 'Padding','replicate');
mux2 = gaussFilterFcn(I);
muy2 = gaussFilterFcn(I0);
muxy = mux2.*muy2;
mux2 = mux2.^2;
muy2 = muy2.^2;
sigmax2 = gaussFilterFcn(I.^2) - mux2;
sigmay2 = gaussFilterFcn(I0.^2) - muy2;
sigmaxy = gaussFilterFcn(I.*I0) - muxy;
num = (2*muxy + c1).*(2*sigmaxy + c2);
den = (mux2 + muy2 + c1).*(sigmax2 + sigmay2 + c2);
ssimmap = num./den;
ssimerror = mean(ssimmap(:));
end