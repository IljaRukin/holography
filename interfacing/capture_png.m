close all;clear;clc;
% addpath('./interfacing');
display_screen = 1;

exposure_times = [50000,100000,200000,400000];
path = '../result/';

%% start camera
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 50000;

%filenames = {'E1.fp.img','E2.fp.img','E3.fp.img'};
files = dir(fullfile(path, '*.png'));
filenames = {files.name};

pause(1);

phiRGB = im2double( imread([path,char(filenames(1))]) );
f1 = display_fullscreen(display_screen,phiRGB);

% pause();

for filename=filenames
    filename = char(filename);
    fprintf("%s \n",filename);
    
    phiRGB = im2double( imread([path,filename]) );
    f1 = display_fullscreen(display_screen,phiRGB);

    for expTime=exposure_times
        src.ExposureTime = expTime;
        pause(0.1);
        frame = getsnapshot(x);
        imwrite(frame,[path,filename(1:end-4),'_exposure',num2str(expTime),'.png']);
    end
    
    %close(f1.Number);
    
end

%% close camera
delete(x)
clear x