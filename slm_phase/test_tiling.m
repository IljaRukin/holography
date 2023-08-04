close all; clear; clc;

%% setup
% M=256;N=256;Dm=0.008;Dn=0.008;lambda=0.000638;z=100;
M=2048;N=2048;Dm=0.008;Dn=0.008;lambda=0.000638;z=100;
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
xx=xx*Dm;yy=yy*Dn;

%% image
% image is alsways first downsampled to M0xN0 and upsampled later to MxN to keep resolution comparable and smooth it in case of upsampling
object_amplitude=double(imread('2butterfly4096.jpg')); imgname='Butterfly';
% object_amplitude=double(imread('USAF-1951_cutout.png')); object_amplitude=scaleValues(-object_amplitude,0,1); imgname='USAF_1961';
% object_amplitude=double(imread('pirate.tiff')); object_amplitude=crop(object_amplitude,N0,M0); imgname='PirateMen';
% object_amplitude = zeros(N,M,1); object_amplitude(M/2,N/2) = 1;  imgname='One_Point';
[Nimg,Mimg]=size(object_amplitude); object_amplitude = flipud(scaleValues(crop(imresize(object_amplitude,M/Mimg),N,M),0,1));
object_amplitude = sqrt(object_amplitude);

%% propagate
antialias = true; zeropad = true;
U_D = angular_spectrum( sqrt(object_amplitude) ,-z,Dm,Dn,lambda,antialias);

%% tiling
U_D = MMAtiling(U_D,32,32);
% U_D = SLMtiling(U_D,32,32);
figure(1);imagesc(angle(U_D)); axis('equal');axis xy;
U_D = U_D/max(abs(U_D(:))); %adjust SLM WF intensity

%% simulate
U_O = angular_spectrum(U_D,z,Dm,Dn,lambda,antialias);
U_O = sq2(U_O);
U_O = U_O/max(abs(U_O(:))); %adjust SLM WF intensity
figure(2);imagesc(U_O); axis('equal');axis xy;
fprintf('NCOV: %.3f \n',myCORR(U_O,object_amplitude));
fprintf('PSNR: %.3f dB \n',myPSNR(U_O,object_amplitude));
fprintf('PSNRHVSM: %.3f dB \n',psnrhvsm(U_O,object_amplitude));
fprintf('SSIM: %.3f \n',mySSIM(U_O,object_amplitude));
% fprintf('PSNR: %.3f \n',psnr(U_O,object_amplitude));
% fprintf('SSIM: %.3f \n',ssim(U_O,object_amplitude));
