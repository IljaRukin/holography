close all;clear;clc;

%% parameters
M=2048; N=2048;
Mslm=1920; Nslm=1080;

%% load transform
load('distorsion_matrix.mat');

%% load reference image
img0 = double(imread('2butterfly4096.jpg')); imgname='Butterfly';
[Nimg,Mimg]=size(img0); img0 = crop(scaleValues(imresize(img0,M/Mimg),0,1),Nslm,Mslm);

figure(1);imagesc(img0);

%% load best quality distorted image
distorted = double(imread( 'Butterfly_ConstantPhase_fullres_z-100_lambda638_Dm8_Dn8.fp_AmpMod_exposure3000.png' ));

%undistort + fliplr
shifted = imwarp(distorted,tform);
shifted = fliplr(shifted);

%calculate cutout region using cross correlation + cutout
[img,ybegin,yend,xbegin,xend] = shift_image(shifted,img0);
%img = shifted(ybegin:yend,xbegin:xend);

%optimization: scale intensity
img = img *(avg(img0)/avg(img));
img_scaling = @(s) sum((img(:)*s-img0(:)).^2);
s = fminbnd(img_scaling,0,2);
img = img*s;

imwrite(img,'processed_fullres.png');

clear img;

%% load example distorted image
distorted = double( imread( 'Butterfly_ConstantPhase_mma16x16_z-100_lambda638_Dm8_Dn8.fp_AmpMod_exposure3000.png' ) );

figure(2);imagesc(distorted);

%undistort + fliplr + cutout
shifted = imwarp(distorted,tform);
shifted = fliplr(shifted);
img = shifted(ybegin:yend,xbegin:xend);
    
%optimization: scale itensity
img = img *(avg(img0)/avg(img));
img_scaling = @(s) sum((img(:)*s-img0(:)).^2);
s = fminbnd(img_scaling,0,2);
img = img*s;

figure(3);imagesc(img);

imwrite(img,'processed_mma16x16.png');
