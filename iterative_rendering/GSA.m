close all; clear; clc;
random_seed = 0;
rng(random_seed);

%% setup
%all units are in mm
%matricies are structured as: (y/N/Dn,x/M/Dm,z), where y/N/Dn=vertial and x/M/Dm=horizontal direction
M = 2048; %rendered window x resolution
N = 2048; %rendered window y resolution
Mslm = 1920; Nslm = 1080; %slm resolution
Dm = 0.008; %SLM x pixel pitch = hologram pixel pitch (except for fresnel propagation)
Dn = 0.008; %SLM y pixel pitch = hologram pixel pitch (except for fresnel propagation)
NpixelX = 4; NpixelY = 4;
lambda = 0.000638; %wavelength
z = -100; %plane distances to SLM (negative = virtual)

%% image
% image is alsways first downsampled to M0xN0 and upsampled later to MxN to keep resolution comparable and smooth it in case of upsampling
object_amplitude=double(imread('2butterfly4096.jpg')); imgname='Butterfly';
% object_amplitude=double(sum(imread('USAF-1951_cutout.png'),3)); object_amplitude=scaleValues(-object_amplitude,0,1); imgname='USAF_1961';
% object_amplitude=double(imread('pirate.tiff')); object_amplitude=crop(object_amplitude,N,M); imgname='PirateMen';
[Nimg,Mimg]=size(object_amplitude); object_amplitude = flipud(crop(scaleValues(imresize(object_amplitude,M/Mimg),0,1),N,M));
%%% add sizebar
% % % if ~strcmp(imgname,'One_Point')
% % %     sizebar = imread('sizebar2mm.png'); sizebar = flipud(scaleValues(imresize(sum(double(sizebar),3),Dm/Dm0),0,0.8));
% % %     object_amplitude((end-1024)/2+1:(end-1024)/2+size(sizebar,1),(end+Mslm)/2-size(sizebar,2)+1:(end+Mslm)/2) = sizebar;
% % % end
object_amplitude = crop(crop(object_amplitude,Nslm,Mslm),N,M); %set outside of SLM to zero
object_amplitude = sqrt(object_amplitude);
zeropad = true; antialias = true;

%%% initial phase
initial_phase = exp(1i*2*pi*imresize(rand(N/2,M/2),2));
EO = object_amplitude.*exp(1i*initial_phase);

best_error = 1;
best_ED = 1;

%%% 2D optimization
% while sum(nosign(sq2(E(:)) - sq2(object_amplitude(:)))) < 0.05
for iter=1:100
    EO = (object_amplitude+1e-5).*exp(1i*angle(EO));
    ED = angular_spectrum(EO,-z,Dm,Dn,lambda,true);
    ED = MMAphasetiling(ED,NpixelX,NpixelY); % TTP-MMA tiling & discard amplitude
    EO = angular_spectrum(ED,z,Dm,Dn,lambda,true);
    EO = EO/max(abs(EO(:)));
%     EO = EO/mean(abs(EO(:)));
    NUMerror = sum(nosign(sq2(EO(:))-sq2(object_amplitude(:))))/numel(EO);
    fprintf('GSA iter %i - error %0.5f \n',iter,NUMerror);
    if NUMerror<best_error
        best_error = NUMerror;
        best_ED = ED;
    end
end
EO = object_amplitude.*exp(1i*angle(EO));

figure(1);imagesc(angle(best_ED)); axis('equal');axis xy;
figure(2);imagesc(sq2(EO)); axis('equal');axis xy;

ED = crop(best_ED,Nslm,Mslm);

path = './WF/';
parameters = ['_z',num2str(z),'_lambda',num2str(lambda*1e+6),'_Dm',num2str(Dm*1e+3),'_Dn',num2str(Dn*1e+3)];
saveFPImage(ED,[path,imgname,'_GSA',parameters,'.fp.img']);