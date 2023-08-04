close all;clear;clc;

Mslm = 1920;
Nslm = 1080;
lambda = 0.000638; offset = 0.75*2*pi; %wavelength + amplitude modulation phase offset
display_screen = 1; %computer screen number on which to display

% filename = '../results/Your_Wavefield.fp.img';
% E = loadFPImage(filename);
% [N,M,~] = size(E);
M=2048;N=2048; E=ones(N,M);

%%% wavefield amplitude/phase
E = E/max(abs(E(:)));
amp0 = abs(E);
phi0 = angle(E);

%%% generate phases for 4f amplitude modulation
[ampphi1,phi1] = AmpMod_phases(E,offset);
%---
phiRGB = zeros(N,M,3);
phiRGB(:,:,1) = ampphi1;
phiRGB(:,:,2) = flipud(fliplr( phi1 ));
phiRGB(:,:,3) = flipud(fliplr( phi0 ));

%scale phase for display
phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
phiRGB = crop( phiRGB ,Nslm,Mslm);

f1 = display_fullscreen(display_screen,phiRGB);

%% start camera
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 10000;
vidRes = x.VideoResolution;

%% live-picture from camera
% f0 = figure(1);
% f0.ToolBar = 'none';
% f0.MenuBar = 'none';
% f0.NumberTitle = 'Off';
% f0.Name = 'My Preview Window';
% % Create the image object in which you want to display
% % the video preview data. Make the size of the image
% % object match the dimensions of the video frames.
% nBands = x.NumberOfBands;
% hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
% % Display the video data in your GUI.
% preview(x, hImage);
% set(gca,'position',[0 0 1 1],'Visible','off')

%% take snapshots
for a=1:1000
    frame = getsnapshot(x);
    imwrite(frame,['../results/loop_',num2str(a,'%03.f'),'.png']);
    pause(0.1);
end