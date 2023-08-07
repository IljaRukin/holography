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
NslmmirrorX = floor(Mslm/NpixelX);
NslmmirrorY = floor(Nslm/NpixelY);
lambda = 0.000638; %wavelength
z = -100; %plane distances to SLM (negative = virtual)

%% image
% image is alsways first downsampled to M0xN0 and upsampled later to MxN to keep resolution comparable and smooth it in case of upsampling
object_amplitude = double(imread('2butterfly4096.jpg')); imgname='Butterfly';
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

%% TTP-MMA parameters
%ED = exp(1i*(piston + alphaX*xARY + alphaY*yARY));
% piston = zeros(NmirrorY,NmirrorX);
% alphaX = zeros(NmirrorY,NmirrorX);
% alphaY = zeros(NmirrorY,NmirrorX);
[xARY, yARY] = meshgrid( (-NpixelX/2+1/2:NpixelX/2-1/2)/NpixelX , (-NpixelY/2+1/2:NpixelY/2-1/2)/NpixelY );
xARY = repmat(xARY,NslmmirrorY,NslmmirrorX); yARY = repmat(yARY,NslmmirrorY,NslmmirrorX);

%% setup
initial_phase = exp(1i*2*pi*imresize(rand(N/2,M/2),2));
EO = object_amplitude.*initial_phase;
ED = angular_spectrum(EO,-z,Dm,Dn,lambda,true); %initial wavefield at SLM
[alphaX, alphaY, piston, ~] = Phase2TTP( crop( ED ,Nslm,Mslm) , NpixelX, NpixelY);
% % % alphaX = rand(size(alphaX))-0.5; alphaY = rand(size(alphaY))-0.5;

%% optimization
ED = crop( TTP2Phase(alphaX, alphaY, piston, NpixelX, NpixelY) ,N,M);
EO = angular_spectrum(ED,z,Dm,Dn,lambda,true); %resulting wavefield at object
EO = EO/max(abs(EO(:)));
% EO = EO/mean(abs(EO(:)));

error = sq2(EO)-sq2(object_amplitude);
NUMerror = sum(nosign(error(:)))/numel(error);
fprintf('iter %i - error %0.5f \n',0,NUMerror);
best_error = NUMerror;
best_ED = ED;

aa = 1; %initial step
for iter=1:100
%     grad = real( -1i.*conj(TTP2Phase(alphaX, alphaY, piston, NpixelX, NpixelY)) .* angular_spectrum(4*EO.*error,-z,Dm,Dn,lambda,true) ); %backpropagation
    grad = real( -1i.* conj(ED) .* angular_spectrum(4*EO.*error,-z,Dm,Dn,lambda,true) ); %backpropagation
    grad = crop( grad ,Nslm,Mslm); %set outside of SLM to zero
    piston = piston - aa*reshape(mean(mean(reshape( grad ,NpixelY,NslmmirrorY,NpixelX,NslmmirrorX),3),1),NslmmirrorY,NslmmirrorX);
    alphaX = alphaX - aa*reshape(mean(mean(reshape( grad.*xARY ,NpixelY,NslmmirrorY,NpixelX,NslmmirrorX),3),1),NslmmirrorY,NslmmirrorX);
    alphaY = alphaY - aa*reshape(mean(mean(reshape( grad.*yARY ,NpixelY,NslmmirrorY,NpixelX,NslmmirrorX),3),1),NslmmirrorY,NslmmirrorX);
    aa = aa*0.99;
    ED = crop( TTP2Phase(alphaX, alphaY, piston, NpixelX, NpixelY) ,N,M);
    EO = angular_spectrum(ED,z,Dm,Dn,lambda,true); %resulting wavefield at object
    EO = EO/max(abs(EO(:)));
%     EO = EO/mean(abs(EO(:)));
    error = sq2(EO)-sq2(object_amplitude);
    NUMerror = sum(nosign(error(:)))/numel(error);
    fprintf('iter %i - error %0.5f \n',iter,NUMerror);
    if NUMerror<best_error
        best_error = NUMerror;
        best_ED = ED;
    end
end

%% results
figure(1);imagesc(angle(best_ED)); axis('equal');axis xy;
figure(2);imagesc(sq2(angular_spectrum( best_ED ,z,Dm,Dn,lambda,true))); axis('equal');axis xy;

ED = crop(best_ED,Nslm,Mslm);

path = './WF/';
parameters = ['_z',num2str(z),'_lambda',num2str(lambda*1e+6),'_Dm',num2str(Dm*1e+3),'_Dn',num2str(Dn*1e+3)];
saveFPImage(ED,[path,imgname,'_WirtingerMMA',parameters,'.fp.img']);