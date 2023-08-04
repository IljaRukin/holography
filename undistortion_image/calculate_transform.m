
%% kontruiere referenz-raster mit jeweils 1mm zwischen den Punkten
%(bei einem Pixelabstand Dm=Dn=0,008mm)
M=2048;N=2048;
Mslm = 1920;Nslm = 1080;
Dm=0.008;Dn=0.008;
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
xx = xx*Dm; yy = yy*Dn;
original = (((xx-1).^2+(yy-1).^2)<(2*Dm)^2) + (((xx+1).^2+(yy-1).^2)<(2*Dm)^2) + (((xx-1).^2+(yy+1).^2)<(2*Dm)^2) + (((xx+1).^2+(yy+1).^2)<(2*Dm)^2);
original = original + ( (((xx-3).^2+(yy-1).^2)<(2*Dm)^2) + (((xx+3).^2+(yy-1).^2)<(2*Dm)^2) + (((xx-3).^2+(yy+1).^2)<(2*Dm)^2) + (((xx+3).^2+(yy+1).^2)<(2*Dm)^2)...
    + (((xx-1).^2+(yy-3).^2)<(2*Dm)^2) + (((xx+1).^2+(yy-3).^2)<(2*Dm)^2) + (((xx-1).^2+(yy+3).^2)<(2*Dm)^2) + (((xx+1).^2+(yy+3).^2)<(2*Dm)^2))*0.5;
original = original + ( (((xx-5).^2+(yy-1).^2)<(2*Dm)^2) + (((xx+5).^2+(yy-1).^2)<(2*Dm)^2) + (((xx-5).^2+(yy+1).^2)<(2*Dm)^2) + (((xx+5).^2+(yy+1).^2)<(2*Dm)^2)...
    + (((xx-1).^2+(yy-5).^2)<(2*Dm)^2) + (((xx+1).^2+(yy-5).^2)<(2*Dm)^2) + (((xx-1).^2+(yy+5).^2)<(2*Dm)^2) + (((xx+1).^2+(yy+5).^2)<(2*Dm)^2))*0.5;
original = crop( original ,Nslm,Mslm);
figure(1);imagesc(original);

%% lade referenzbild
distorted = imread('reference.png');
figure(2);imagesc(distorted);

%% undistort
% undistorted = undistort_image(distorted,original); %automatic
[distortedPoints,originalPoints] = cpselect(distorted,original,'Wait',true); %manual

tform = fitgeotrans(distortedPoints,originalPoints,'affine');
tformInv = invert(tform);
Roriginal = imref2d(size(original));
undistorted = imwarp(distorted,tform,'OutputView',Roriginal);

figure(3);imagesc(undistorted);

%% save transform
save('distorsion_matrix.mat','tform');
