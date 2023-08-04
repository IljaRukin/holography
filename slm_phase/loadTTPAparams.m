function [amp,piston,alphaX,alphaY] = loadTTPAparams(fname,lambda,Dm,Dn)
% value ranges
% amp = [0,1]
% piston = [0,2*pi]
% alphaX,alphaY = [-2*pi/lambda/p,2*pi/lambda/p] (45° slope)

%[amp, piston, alphaX, alphaY]
load(fname);

maxVal = 2^16-1;
amp = double(amp)/maxVal;
piston = (double(piston)-(maxVal-1)/2)/maxVal*(2*pi);
alphaX = (double(alphaX)-(maxVal-1)/2)/maxVal*(4*pi)/(lambda*Dm);
alphaY = (double(alphaY)-(maxVal-1)/2)/maxVal*(4*pi)/(lambda*Dn);

end

