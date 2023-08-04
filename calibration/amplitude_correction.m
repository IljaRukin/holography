close all;clear;clc;

Mslm = 1920;
Nslm = 1080;
lambda = 0.000638; offset = 0.75*2*pi; %wavelength + amplitude modulation phase offset
display_screen = 1; %computer screen number on which to display

%%%start camera
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 10000;
vidRes = x.VideoResolution;

%%%live-picture from camera
display_live = false;
if display_live
    f0 = figure(1);
    f0.ToolBar = 'none';
    f0.MenuBar = 'none';
    f0.NumberTitle = 'Off';
    f0.Name = 'My Preview Window';
    % Create the image object in which you want to display
    % the video preview data. Make the size of the image
    % object match the dimensions of the video frames.
    nBands = x.NumberOfBands;
    hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
    %%%Display the video data in your GUI.
    preview(x, hImage);
    set(gca,'position',[0 0 1 1],'Visible','off')
    movegui(f0,[-2200 0]);
end

%%%capture intensity
phiSLM = ones(Nslm,Mslm,3)*offset;
phiSLM = mod(phiSLM/(2*pi),1) *lambda/0.000633;
pause(1.0);
display_fullscreen(display_screen,phiSLM);
pause(1.0);
I = getsnapshot(x);
imwrite(I,['amplitude_correction_uncalibrated_exp',num2str(src.ExposureTime),'.png']);
src.ExposureTime = 3*src.ExposureTime;
pause(1);
I = getsnapshot(x);
imwrite(I,['amplitude_correction_uncalibrated_',num2str(src.ExposureTime),'.png']);
src.ExposureTime = src.ExposureTime/3;

%min/max pixel position of SLM on camera sensor
%automatic detection enabled if size_manual = false
size_manual = false;
py_min = 168;
py_max = 776;
px_min = 129;
px_max = 1200;
%cut following number of pixels from edges of SLM for fitting
nPixCut = 0;
if ~size_manual
    phiSLM = ones(Nslm,Mslm,3)*(offset+pi);
    phiSLM = mod(phiSLM/(2*pi),1) *lambda/0.000633;
    display_fullscreen(display_screen,phiSLM);
    pause(1.0);
    I0 = getsnapshot(x);
    pause(1.0);
    difference = sq2(I-I0);
    difference = difference/max(difference(:));
%     average = sum(sum(difference,1),2)/numel(difference);
%     difference = difference > average;
    x_diff = sum(difference,1);
    y_diff = sum(difference,2);
    step_fkt = [linspace(-1,-1,100),linspace(1,1,100)];
    x_diff = conv(x_diff,step_fkt,'same');
    y_diff = conv(y_diff,step_fkt,'same');
    [~,px_min] = min(x_diff); px_min = px_min+1;
    [~,px_max] = max(x_diff);
    [~,py_min] = min(y_diff); py_min = py_min+1;
    [~,py_max] = max(y_diff);
end

figure(1);imagesc(I);

%cut (SLM area - nPixCut) out
I_fit = I(py_min+nPixCut:py_max-nPixCut,px_min+nPixCut:px_max-nPixCut);
%blur
I_fit = imgaussfilt(I_fit,50);

%put grid on captured image
[ny,nx] = size(I_fit);
xGrid = (-(nx-1)/2:(nx-1)/2) /(nx/2);
yGrid = (-(ny-1)/2:(ny-1)/2) /(ny/2);
[xGrid,yGrid] = meshgrid(xGrid,yGrid);

%produce grid for interpolation on SLM
nyAll = ny + nPixCut*2;
nxAll = nx + nPixCut*2;
xGridAll = linspace(-(nxAll-1)/nx,(nxAll-1)/nx,Mslm);
yGridAll = linspace(-(nyAll-1)/ny,(nyAll-1)/ny,Nslm);
[xGridAll,yGridAll] = meshgrid(xGridAll,yGridAll);

%interpolate
[xFit,yFit,zFit] = prepareSurfaceData(xGrid,yGrid,I_fit);
% fit_s = fit([xFit,yFit],zFit,'linearinterp');
% fit_s = fit([xFit,yFit],zFit,'cubicinterp');
fit_s = fit([xFit,yFit],zFit,'poly22');
% fit_mat = fit_s(xGrid,yGrid)*maxdPhi; %fit on cutout area (test)
amp_correct = fit_s(xGridAll,yGridAll); %fit for SLM
% figure(3);imagesc(amp_correct);
amp_correct = amp_correct/max(amp_correct(:));
amp_correct = sqrt(amp_correct);

%elementwise division and scaling
amp_correct = 1./amp_correct;
amp_correct = amp_correct/max(amp_correct(:));
amp_correct = min(max(amp_correct,0.001),0.99)+0.01; %clip low/high values

%save
save('amp_correct','amp_correct');

[N,M] = size(amp_correct);
E = complex(ones(N,M));
E = E.*amp_correct;
% E = E/max(abs(E(:)));
[ampphi1,phi1] = AmpMod_phases(E,offset);
phiRGB = zeros(N,M,3);
phiRGB(:,:,1) = flipud(fliplr( ampphi1 ));
phiRGB(:,:,2) = phi1;
phiRGB(:,:,3) = 0;

%display corrected phase
phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
f1 = display_fullscreen(display_screen,phiRGB);

pause(1);
I = getsnapshot(x);
imwrite(I,['amplitude_correction_calibrated_exp',num2str(src.ExposureTime),'.png']);
src.ExposureTime = 5*src.ExposureTime;
pause(1);
I = getsnapshot(x);
imwrite(I,['amplitude_correction_calibrated_',num2str(src.ExposureTime),'.png']);
src.ExposureTime = 10*src.ExposureTime;
pause(1);
I = getsnapshot(x);
imwrite(I,['amplitude_correction_calibrated_',num2str(src.ExposureTime),'.png']);

%%%close camera
if display_live
    close 'My Preview Window'
end
delete(x)
clear x