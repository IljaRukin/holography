%for time multiplexing speckle reduction
close all;clear;clc;

%path to wavefield data ".fp.img"
path = './';

%filenames = {'E1.fp.img','E2.fp.img','E3.fp.img'};
files = dir(fullfile(path, '*.png'));
filenames = {files.name};

nr = numel(filenames);
img = 0;

for filename=filenames
    filename = char(filename);
    fprintf("%s \n",filename);
    
    filename = [num2str(k,'%02.f'),'.png'];
    img = img + double(imread(filename))/nr;
end
% figure(2);imagesc(img);
imwrite(uint8(img/N),'mean_intensity.png');
