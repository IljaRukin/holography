function [E_tiled] = MMAphasetiling(E,NpixelX,NpixelY,subsample)
%tile wavefield for mirror-array (tip-tilt-piston terms)

if nargin < 4
	subsample = 1;
end

if NpixelX==1 && NpixelY==1 && subsample==1
    E_tiled = E;
    return;
end

if (subsample>NpixelX) | (subsample>NpixelY)
    error('cannot subsample by more then the number of samples per Pixel');
end

%reduce size to multiples of PixPerMirror
[N0,M0,~] = size(E);
NmirrorX = floor(M0/NpixelX);
NmirrorY = floor(N0/NpixelY);
E = crop(E ,NmirrorY*NpixelY,NmirrorX*NpixelX);

% convert phase to tip, tilt, piston
[alphaX, alphaY, piston, ~] = Phase2TTP(E, NpixelX, NpixelY);
clear E;

%%% compression bottleneck here

% convert tip, tilt, piston to phase
M0 = round(M0/subsample); N0 = round(N0/subsample);
NpixelX = round(NpixelX/subsample); NpixelY = round(NpixelY/subsample); %upsampling with 1/subsample
E_tiled = TTP2Phase(alphaX, alphaY, piston, NpixelX, NpixelY);
clear MA_alpha; clear MA_beta; clear MA_pist;

%adjust size
E_tiled = crop(E_tiled,N0,M0);

end