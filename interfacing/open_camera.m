%% start camera
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 1000;
vidRes = x.VideoResolution;

%% live-picture from camera
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
% Display the video data in your GUI.
preview(x, hImage);
set(gca,'position',[0 0 1 1],'Visible','off')

%% get one snapshot
%{
frame = getsnapshot(x);
figure(998);imshow(frame);
imwrite(frame,'myIMG.png');
%}

%% close camera
%{
close 'My Preview Window'
delete(x)
clear x
%}