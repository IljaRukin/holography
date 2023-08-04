close all;clear;clc;

%% coordinates
M = 2048; N = 2048;
Mslm = 1920; Nslm = 1080;
[y,x] = ndgrid(-Nslm/2:Nslm/2-1,-Mslm/2:Mslm/2-1);
r = sqrt(x.^2 + y.^2);

%% load reference image
img0 = double(imread('2butterfly4096.jpg')); imgname='Butterfly';
[Nimg,Mimg]=size(img0); img0 = crop(scaleValues(imresize(img0,M/Mimg),0,1),Nslm,Mslm);

figure(1);imagesc(img0);

%% load best quality distorted image
img = double(imread( 'processed_fullres.png' ))/255;

figure(2);imagesc(img);

%% get reference points
[distortedPoints,originalPoints] = cpselect(img,img0,'Wait',true);

xO = originalPoints(:,1)-1-Mslm/2;
yO = originalPoints(:,2)-1-Nslm/2;
rO = sqrt(xO.^2+yO.^2);

xD = distortedPoints(:,1)-1-Mslm/2;
yD = distortedPoints(:,2)-1-Nslm/2;

%% distortion
%k(1) scale
%k(2-4) radial
%k(5-6) tangential
%k(7-8) shift
%k(9) rotation
% distortX = @(k) xO.*(k(1) + k(2)*rO.^2 + k(3)*rO.^3 + k(4)*rO.^1) + k(5)*2*xO.*yO + k(6)*(rO.^2 + 2*xO.^2)+k(7);
% distortY = @(k) yO.*(k(1) + k(2)*rO.^2 + k(3)*rO.^3 + k(4)*rO.^1) + k(6)*2*xO.*yO + k(5)*(rO.^2 + 2*yO.^2)+k(8);

%setup matrix
nn = size(xO,1);
A = zeros(2*nn,9); b = zeros(2*nn,1);
for p = 1:nn
A(2*p-1,:) = [xO(p),0,xO(p).*rO(p).^2,xO(p).*rO(p).^3,xO(p).*rO(p).^1,2*xO(p).*yO(p),rO(p).^2+2*xO(p).^2,1,0];
A(2*p,:) = [0,yO(p),yO(p).*rO(p).^2,yO(p).*rO(p).^3,yO(p).*rO(p).^1,rO(p).^2+2*xO(p).^2,2*xO(p).*yO(p),0,1];
b(2*p-1) = xD(p);
b(2*p) = yD(p);
end

%solve
tol = 1e-30; 
maxit = 200;
k = lsqr(A,b,tol,maxit);

%undistort image
distortionX = @(k) x.*(k(1) + k(3)*r.^2 + k(4)*r.^3 + k(5)*r.^1) + 2*k(6)*x.*y + k(7)*(r.^2 + 2*x.^2)+k(8);
distortionY = @(k) y.*(k(2) + k(3)*r.^2 + k(4)*r.^3 + k(5)*r.^1) + 2*k(7)*x.*y + k(6)*(r.^2 + 2*y.^2)+k(9);
img1 = interp2(img,distortionX(k)+1+Mslm/2,distortionY(k)+1+Nslm/2,'linear',0.3);
img1(isnan(img1))=0;

figure(3);imagesc(img1);

%% add small translation,rotation,scale corrections
[optimizer, metric] = imregconfig('monomodal');
% img2 = imregister(img1,img0,'similarity',optimizer,metric);
tform = imregtform(img1,img0,'similarity',optimizer,metric);
img2 = imwarp(img1,tform,'OutputView',imref2d(size(img0)));

figure(4);imagesc(img2);

%% combine distortion + translation,rotation,scale
xtrafo = imwarp( distortionX(k)+1+Mslm/2 ,tform,'OutputView',imref2d(size(img0)));
ytrafo = imwarp( distortionY(k)+1+Nslm/2 ,tform,'OutputView',imref2d(size(img0)));
save('distorsion_interpolation.mat','xtrafo','ytrafo');
img3 = interp2(img,xtrafo,ytrafo,'linear',0.3); img3(isnan(img3))=0;

figure(5);imagesc(img3);
