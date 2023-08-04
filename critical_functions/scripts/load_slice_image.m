close all;clear;clc;
scale = @(x) (x-min(x(:)))/(max(x(:))-min(x(:)));

sourcepath = '...';
destinationpath = '...';

%{
%adjust resizing
I0 = imread('C:\Users\User\Desktop\Google Drive\DMD display\matlab von Claas (etwas verändert)\nurlogo_sw_1000.png');
I0 = scale(im2double(I0(:,:,1)));
I = imread('C:\Users\User\Desktop\Google Drive\DMD display\images\new 1000px amplitude modulation\nonrandom_10000us_100_amp.png');
I = scale(im2double(I));
imagesc(imresize(I0,[200,200])-flipud(imresize(I(135:548,553:955),[200,200])));colorbar();
%}

files = dir(fullfile(sourcepath, '*.png'));
filenames = {files.name};

for filename=filenames
    filename = char(filename);
    fprintf('%s \n',filename);
    img = scaleValues(im2double(imread([sourcepath,filename])),0,1);
    img = img(135:548,553:955);
    img = scaleValues(img,0,1);
    imwrite(img,[destinationpath,filename(1:end-4),'_cropped.png']);
end
