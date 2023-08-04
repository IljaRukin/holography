function [amp1,phi1] = AmpMod_phases(E,offset)
%calculate two phases for amplitude modulation with 4f setup.

%% ---2SLM amplitude & phase---
phase = angle(E);
amplitude = abs(E);
% amplitude = scaleValues(amplitude,0.05,0.99);
if offset<=0.5
    amp1 = offset + 2*acos( amplitude );
else
    amp1 = offset - 2*acos( amplitude );
end
phi1 = phase - 0.5*amp1;

%% postprocessing
amp1 = real(amp1);
phi1 = real(phi1);

end