% close all;clear;clc;

Mslm = 1920;Nslm = 1080;
lambda = 0.0006328; offset = 0.75*2*pi; %wavelength + amplitude modulation phase offset
%lambda = 0.000532; offset = 0.45*2*pi; %wavelength + amplitude modulation phase offset
display_screen = 1; %computer screen number on which to display

%%%load wavefield
filename = '../results/Your_Wavefield.fp.img';
E = loadFPImage(filename);
[N,M,~] = size(E);

%%%point source
% M=2048;N=2048; Dm=0.008;Dn=0.008; subsample=1; z=90;
% [yy,xx] = ndgrid(-N*subsample/2:N*subsample/2-1,-M*subsample/2:M*subsample/2-1); %discrete: k,l,m,n
% xx = xx*Dm; yy = yy*Dn;
% E = exp(sign(z)*1i*2*pi/lambda*sqrt((xx.^2+yy.^2)/(subsample^2)+z^2));
% % E = E .* ((xx.^2+yy.^2)<=(z*tan(asin(lambda/(2*Dm))))^2); %antialias
% if subsample>1
% E = exp(1i*reshape(mean(mean(reshape( angle(E) ,(subsample),N,(subsample),M),3),1),N,M));
% end

% %%%four point sources - 2mm
% M=2048;N=2048; Dm=0.008;Dn=0.008; z=100;
% [yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
% xx = xx*Dm; yy = yy*Dn;
% E = exp(sign(z)*1i*2*pi/lambda*sqrt((xx-1).^2+(yy-1).^2+z^2))+exp(sign(z)*1i*2*pi/lambda*sqrt((xx+1).^2+(yy-1).^2+z^2))+...
%     exp(sign(z)*1i*2*pi/lambda*sqrt((xx-1).^2+(yy+1).^2+z^2))+exp(sign(z)*1i*2*pi/lambda*sqrt((xx+1).^2+(yy+1).^2+z^2));

%%%empty image
% M=2048;N=2048;
% E = ones(N,M);

%add phase calibration, if file exist and correctPhase=true
correctPhase = false;
if correctPhase && (exist('../calibration/dPhi_SLM.mat', 'file') == 2)
    dPhi_SLM = load('dPhi_SLM.mat');
    dPhi_SLM = crop( dPhi_SLM.dPhi_SLM ,N,M);
    E = E.*exp(1i*2*pi*dPhi_SLM);
end

%add amplitude calibration, if file exist and correctAmplitude=true
correctAmplitude = false;
if correctAmplitude && (exist('amp_correct.mat', 'file') == 2)
    amp_correct = load('../calibration/amp_correct.mat');
    amp_correct = flipud(fliplr( crop( amp_correct.amp_correct ,N,M) ));
    E = E.*amp_correct;
end

%%%tiling
% PixPerMirror = 2;
% E = MMAtiling(E,PixPerMirror,PixPerMirror);
% E = SLMtiling(E,PixPerMirror,PixPerMirror);

%%%modify wavefield
%%%scale
E = E/max(abs(E(:)));
%%%binary amplitude modulation
%E = (abs(E)>0.2).*exp(i*angle(E));
%%%phase only modulation
%E = exp(angle(i*E));

%%% wavefield amplitude/phase
amp0 = abs(E);
phi0 = angle(E);

%%% generate phases for relph
% [phi1,phi2] = RELPH_phases(E);
% %---
% phiRGB = zeros(N,M,3);
% phiRGB(:,:,2) = phi2;
% phiRGB(:,:,3) = fliplr( phi1 );

%%% generate phases for 4f amplitude modulation
[ampphi1,phi1] = AmpMod_phases(E,offset);
%---
phiRGB = zeros(N,M,3);
phiRGB(:,:,1) = ampphi1;
phiRGB(:,:,2) = flipud(fliplr( phi1 ));
phiRGB(:,:,3) = flipud(fliplr( phi0 ));

%%% generated phases with unit amplitude modulation
% phiRGB = zeros(N,M,3);
% phiRGB(:,:,1) = offset;
% phiRGB(:,:,2) = phi0;
% phiRGB(:,:,3) = phi0;

%scale phase for display
phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
phiRGB = crop( phiRGB ,Nslm,Mslm);

f1 = display_fullscreen(display_screen,phiRGB);