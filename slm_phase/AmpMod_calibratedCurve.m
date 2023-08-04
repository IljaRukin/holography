function [amp1,phi1] = AmpMod_calibratedCurve(E,offset)
%generate phases for amplitude modulation with 4f setup from calibrated intensity curve,
%which is generated with "amplitude_correction.m"

%% ---2SLM custom amplitude & phase---
phase = angle(E);
amplitude = abs(E);
load('../calibration/ampmod.mat');
xx = scaleValues(amplitude,amprange(1),amprange(2));
amp1 = mod( polyval(ampcoeff,xx) ,2*pi);
phi1 = mod( phase - 0.5*amp1 ,2*pi);

%% postprocessing
amp1 = real(amp1);
phi1 = real(phi1);

end