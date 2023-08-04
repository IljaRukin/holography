% close all;clear;clc;
M = 2048; N = 2048;
Mslm = 1920; Nslm = 1080;
lambda = 0.0006328; %wavelength + amplitude modulation phase offset
display_screen = 1;

phiRGB = zeros(Nslm,Mslm,3);
phiRGB(:,:,1) = 0; %amplitude modulation SLM; set to "offset" for unit amplitude
phiRGB(:,:,2) = 0; %phase modulation SLM
phiRGB(:,:,3) = 0; %not connected

%% 2D rectangle (justage)
% r = 30;
% phiRGB((Nslm/2-r+1):(Nslm/2+r),(Mslm/2-r+1):(Mslm/2+r),1:2) = 1;

%% 2D center cross (justage)
% phiRGB(Nslm/2:Nslm/2+1,:,1) = 1;
% phiRGB(:,Mslm/2:Mslm/2+1,1) = 1;
% phiRGB(:,:,2) = trace_line(1,1,Mslm,Nslm,phiRGB(:,:,2)); phiRGB(:,:,2) = trace_line(1,2,Mslm-1,Nslm,phiRGB(:,:,2)); phiRGB(:,:,2) = trace_line(2,1,Mslm,Nslm-1,phiRGB(:,:,2));
% phiRGB(:,:,2) = trace_line(Mslm,1,1,Nslm,phiRGB(:,:,2)); phiRGB(:,:,2) = trace_line(Mslm-1,1,1,Nslm-1,phiRGB(:,:,2)); phiRGB(:,:,2) = trace_line(Mslm,2,2,Nslm,phiRGB(:,:,2));

%% simple grid (justage)
edgeWidth = 5;
distance_lines = 256;
for l=-ceil(edgeWidth/2):ceil(edgeWidth/2)
    phiRGB(round(distance_lines/2)+l:distance_lines:Nslm-round(distance_lines/2)+l,:,1:2) = 1;
    phiRGB(:,round(distance_lines/2)+l:distance_lines:Mslm-round(distance_lines/2)+l,1:2) = 1;
end

%% transform
phiRGB = phiRGB*pi;
phiRGB(:,:,1) = phiRGB(:,:,1); %amplitude modulation
phiRGB(:,:,2) = flipud(fliplr( phiRGB(:,:,2) )); %phase modulation
phiRGB(:,:,3) = flipud(fliplr( phiRGB(:,:,3) )); %not connected

%% scale phase for display
phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
phiRGB = crop( phiRGB ,Nslm,Mslm);

f1 = display_fullscreen(display_screen,phiRGB);