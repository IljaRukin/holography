close all;clear;clc;

%% parameters
M=2048; N=2048;
Mslm=1920; Nslm=1080;

[yy,xx] = ndgrid(-Nslm/2:Nslm/2-1,-Mslm/2:Mslm/2-1);
gauss = @(x) x(1)*exp(1/(x(2)^2)*((yy-x(3)).^2+(xx-x(4)).^2));

%% load transforms
load('distorsion_matrix.mat');
load('distorsion_interpolation.mat');

%% load reference image
img0 = double(imread('2butterfly4096.jpg'));
[Nimg,Mimg]=size(img0); img0 = crop(scaleValues(imresize(img0,M/Mimg),0,1),Nslm,Mslm);

figure(1);imagesc(img0);

%% load best quality distorted image + undistort + fliplr
img = double(imread( 'processed_fullres.png' ))/255;

%% load best quality distorted image
distorted = double(imread( 'Butterfly_ConstantPhase_fullres_z-100_lambda638_Dm8_Dn8.fp_AmpMod_exposure3000.png' ));

%undistort + fliplr
shifted = imwarp(distorted,tform);
shifted = fliplr(shifted);

%calculate cutout region using cross correlation + cutout
[img,ybegin,yend,xbegin,xend] = shift_image(shifted,img0);
%img = shifted(ybegin:yend,xbegin:xend);

%optimization: correct intensity by gaussian curve
img = img *(avg(img0)/avg(img));
img_gaussian = @(x) sum(sum( (img.*gauss(x) - img0).^2 )); %(s,sigma,x0,y0)
[x,fval,exitflag,output] = fminsearch(img_gaussian,[1,800,0,0]);
img = img.*gauss(x);

imwrite(img,'processed_mod_fullres.png');

clear img;

%% load example distorted image
distorted = double( imread( 'Butterfly_ConstantPhase_mma16x16_z-100_lambda638_Dm8_Dn8.fp_AmpMod_exposure3000.png' ) );

figure(2);imagesc(distorted);

shifted = imwarp(distorted,tform);
shifted = fliplr(shifted);
img = shifted(ybegin:yend,xbegin:xend);

%transform
img = interp2(img,xtrafo,ytrafo,'linear',0.3);
img(isnan(img))=0;

%gauss intensity correction
img = img.*gauss(x);

%scale intensity
img = img *(avg(img0)/avg(img));
img = max(min(img,1),0); %clamp

fprintf('CORR: %.3f \n',myCORR(img,img0));
fprintf('PSNR: %.3f \n',myPSNR(img,img0));
fprintf('SSIM: %.3f \n',mySSIM(img,img0));
fprintf('HVSM: %.3f \n',psnrhvsm(img,img0));

figure(3);imagesc(img);

imwrite(img,'processed_mod_mma16x16.png');
