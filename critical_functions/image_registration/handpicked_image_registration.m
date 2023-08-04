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

%% pick common points and compute distortion matrix
[distortedPoints,originalPoints] = cpselect(distorted,original,"Wait",true);

% tform = fitgeotrans(distortedPoints,originalPoints,'projective');
tform = fitgeotrans(distortedPoints,originalPoints,'affine');
tformInv = invert(tform);
Roriginal = imref2d(size(original));
undistorted = imwarp(distorted,tform,'OutputView',Roriginal);

figure(3);imagesc(undistorted);
