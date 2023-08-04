close all; clear; clc;

%% load image
original = imread("cameraman.tif");
%imwrite(img,'cameraman.tif');

figure(1);imagesc(original);

%% distort image
theta = 170;
rot = [
    cosd(theta) -sind(theta) 0; ... 
    sind(theta)  cosd(theta) 0; ... 
    0 0 1]; 
sc = 2.3;
scale = [sc 0 0; 0 sc 0; 0 0 1]; 
sh = 0.1;
shear = [1 sh 0; 0 1 0; 0 0 1]; 

tform = affine2d(shear*scale*rot);
distorted = imwarp(original,tform);
distorted = imnoise(distorted,"gaussian");

figure(2);imagesc(distorted);

%% approx register image - (fourier-space) phase correlation
tformEstimate = imregcorr(distorted,original);

Rfixed = imref2d(size(original));
undistort1 = imwarp(distorted,tformEstimate,'OutputView',Rfixed);

figure(3);imagesc(undistort1);

%% approx register image - intensity-based
% [optimizer, metric] = imregconfig('monomodal');
% optimizer.MaximumIterations = 50;
% tformEstimate = imregtform(distorted,original,"similarity",optimizer,metric, 'InitialTransformation',tformEstimate);
% 
% Rfixed = imref2d(size(original));
% undistort2 = imwarp(distorted,tformEstimate,'OutputView',Rfixed);
% 
% figure(4);imagesc(undistort2);

%% register image - intensity-based
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 300;
undistorted = imregister(distorted, original, 'affine', optimizer, metric, 'InitialTransformation',tformEstimate);

figure(5);imagesc(undistorted);
