close all;clear;clc;

path = './';
%filenames = {'E1.fpimg','E2.fpimg','E3.fpimg'};
files = dir(fullfile(path, '*.png'));
filenames = {files.name};

init = true;
for filename=filenames
    [I, cmap] = imread([path,filename(1:end-4),'_',sprintf('%01.0f',posy),'_',sprintf('%01.0f',posx),filename(end-3:end)]);
    [I,cmap] = rgb2ind(I,256);
    if init==true
        imwrite(I,cmap,[path,filename(1:end-4),'.gif'],'gif', 'Loopcount',inf);
        init = false;
    else 
        imwrite(I,cmap,[path,filename(1:end-4),'.gif'],'gif','WriteMode','append','DelayTime',0.1); 
    end
end
