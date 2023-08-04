close all;clear;clc;

%path to wavefield data ".fp.img"
path = './';

%filenames = {'E1.fp.img','E2.fp.img','E3.fp.img'};
files = dir(fullfile(path, '*.fp.img'));
filenames = {files.name};

nr = numel(filenames);
E = 0;

for filename=filenames
    filename = char(filename);
    fprintf("%s \n",filename);
    
    E0 = loadFPImage([path,filename]);
    [N,M,~] = size(E0);
    
    E = E + E0/nr;
end

saveFPImage(E,[path,'wavefield_average.fp.img']);