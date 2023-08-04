function [phase_tiled] = SLMphasetiling(phi,NpixelX,NpixelY,subsample)
%tile wavefield for SLM (piston term)
%with subsample the resulting wavefield is downsized by this factor

if nargin < 4
	subsample = 1;
end

if NpixelX==1 && NpixelY==1 && subsample==1
    phase_tiled = phi;
    return;
end

if (subsample>NpixelX) | (subsample>NpixelY)
    error('cannot subsample by more then then the number of samples per Pixel');
end

%reduce size to multiples of PixPerMirror
[N0,M0,~] = size(phi);
NmirrorX = floor(M0/(NpixelX));
NmirrorY = floor(N0/(NpixelY));
phi = crop(phi ,NmirrorY*(NpixelY),NmirrorX*(NpixelX));

% average phase
phi_tiled = reshape(mean(mean(reshape( phi ,(NpixelY),NmirrorY,(NpixelX),NmirrorX),3),1),NmirrorY,NmirrorX);
clear E;

%%% compression bottleneck here

% expand amplitude/phase array size
M0 = round(M0/subsample); N0 = round(N0/subsample);
NpixelX = round(NpixelX/subsample); NpixelY = round(NpixelY/subsample); %upsampling with 1/subsample
phase_tiled = zeros(NmirrorY*NpixelY,NmirrorX*NpixelX);
for m=1:NpixelX
    for n=1:NpixelY
        phase_tiled(n:NpixelY:end,m:NpixelX:end)=phi_tiled;
    end
end

%adjust size
phase_tiled = crop(phase_tiled,N0,M0);

end