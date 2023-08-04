close all;clear;clc;
addpath('../interfacing');

Mslm = 1920;
Nslm = 1080;
lambda = 0.000638;
display_screen = 1;
phaseshift_colorchannel = 1;

%min/max pixel position of SLM on camera sensor
%automatic detection enabled if size_manual = false
size_manual = true;
py_min = 300;
py_max = 700;
px_min = 200;
px_max = 900;
%cut following number of pixels from edges of SLM for fitting
nPixCut = 0;

%%%start camera
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 20000;
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
end

%%%preallocation + phases for capture
I = zeros(vidRes(2),vidRes(1),4);
phase = [0, pi/2, pi, 3/2*pi];
phiSLM = zeros(Nslm,Mslm,3);


for nn = 1:4
    phiSLM(:,:,phaseshift_colorchannel) = ones(Nslm,Mslm) * phase(nn)/(2*pi);
    phiSLM = phiSLM *lambda/0.000633;

    display_fullscreen(display_screen,phiSLM);
    
    %take image
    pause(1.0);
    I(:,:,nn) = getsnapshot(x);
    pause(1.0);
    fprintf('current phase displayed: %i \n',nn);
end

%min max display position in pixel
if ~size_manual
    difference = zeros(size(I(:,:,1)));
    for k=1:4
        for l=k:4
            difference = difference + abs(I(:,:,k)-I(:,:,l));
        end
    end
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
%display found image corners
frame =I(:,:,1);
frame(py_min-5:py_min+5,px_min-5:px_min+5) = 300;
frame(py_min-5:py_min+5,px_max-5:px_max+5) = 300;
frame(py_max-5:py_max+5,px_min-5:px_min+5) = 300;
frame(py_max-5:py_max+5,px_max-5:px_max+5) = 300;
figure(999);imagesc(frame);

%compute phase
%I = single(I);
% deltaPhi = -atan2( (I(:,:,3) - 2*I(:,:,2) + I(:,:,1)) , (I(:,:,1)-I(:,:,3)) );
deltaPhi = atan2( I(:,:,2)-I(:,:,4) , I(:,:,1)-I(:,:,3) );

% figure;
% imshow(deltaPhi,[]), title('deltaPhi') 

%cut (SLM area - nPixCut) out
dPhi_fit = deltaPhi(py_min+nPixCut:py_max-nPixCut,px_min+nPixCut:px_max-nPixCut);
%unwrap & normalize to 1
dPhi_fit = unwrap(unwrap(dPhi_fit,[],2));
maxdPhi = max(dPhi_fit(:));
dPhi_fit = dPhi_fit/maxdPhi;

%put grid on captured image
[ny,nx] = size(dPhi_fit);
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
[xFit,yFit,zFit] = prepareSurfaceData(xGrid,yGrid,dPhi_fit);
fit_s = fit([xFit,yFit],zFit,'poly55'); %'poly22_CrossTerms'
% fit_mat = fit_s(xGrid,yGrid)*maxdPhi; %fit on cutout area (test)
fit_matAll = fit_s(xGridAll,yGridAll)*maxdPhi; %fit for SLM

%prepare for display
dPhi = fit_matAll;
dPhi = mod(dPhi,2*pi);
dPhi_SLM = dPhi/(2*pi);

%save
save('dPhi_SLM','dPhi_SLM');

%put into image
phiSLM = zeros(Nslm,Mslm,3);
phiSLM(:,:,phaseshift_colorchannel) = dPhi_SLM;
phiSLM = phiSLM *lambda/0.000633;

%display corrected phase
display_fullscreen(display_screen,phiSLM);

%%%close camera
if display_live
    close 'My Preview Window'
end
delete(x)
clear x