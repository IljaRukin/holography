function [E_tiled] = SLMtiling(E,NpixelX,NpixelY,subsample)
%tile wavefield for SLM (piston term)
%with subsample the resulting wavefield is downsized by this factor

if nargin < 4
	subsample = 1;
end

if NpixelX==1 && NpixelY==1 && subsample==1
    E_tiled = E;
    return;
end

if (subsample>NpixelX) | (subsample>NpixelY)
    error('cannot subsample by more then then the number of samples per Pixel');
end

%reduce size to multiples of PixPerMirror
[N0,M0,~] = size(E);
NmirrorX = floor(M0/(NpixelX));
NmirrorY = floor(N0/(NpixelY));
E = crop(E ,NmirrorY*(NpixelY),NmirrorX*(NpixelX));

% average amplitude/phase
amp_tiled = reshape(mean(mean(reshape( abs(E) ,(NpixelY),NmirrorY,(NpixelX),NmirrorX),3),1),NmirrorY,NmirrorX);
phi_tiled = reshape(mean(mean(reshape( angle(E) ,(NpixelY),NmirrorY,(NpixelX),NmirrorX),3),1),NmirrorY,NmirrorX);
clear E;

%%% compression bottleneck here

% expand amplitude/phase array size
M0 = round(M0/subsample); N0 = round(N0/subsample);
NpixelX = round(NpixelX/subsample); NpixelY = round(NpixelY/subsample); %upsampling with 1/subsample
amplitude_tiled = zeros(NmirrorY*NpixelY,NmirrorX*NpixelX);
phase_tiled = zeros(NmirrorY*NpixelY,NmirrorX*NpixelX);
for m=1:NpixelX
    for n=1:NpixelY
        amplitude_tiled(n:NpixelY:end,m:NpixelX:end)=amp_tiled;
        phase_tiled(n:NpixelY:end,m:NpixelX:end)=phi_tiled;
    end
end

%recompine (real) amplitude with (complex) phase only wavefield
E_tiled = amplitude_tiled.*exp(1i*phase_tiled);

%adjust size
E_tiled = crop(E_tiled,N0,M0);

end