function [error] = myPSNR(I,I0)
%compute PSNR error
% I0=scaleValues(I0,0,1); I=scaleValues(I,0,1);
MSE=sum((I(:)-I0(:)).^2)/numel(I);
error=10*log10(1/MSE);
end