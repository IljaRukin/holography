close all;clear;clc;

path = './';
%filenames = {'E1.fpimg','E2.fpimg','E3.fpimg'};
files = dir(fullfile(path, '*.png'));
filenames = {files.name};

writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 50; % video fps
open(writerObj);
for filename=filenames
    [I, cmap] = imread([path,filename(1:end-4),'_',sprintf('%01.0f',posy),'_',sprintf('%01.0f',posx),filename(end-3:end)]);
     writeVideo(writerObj, im2frame(I, cmap));
end
close(writerObj);
