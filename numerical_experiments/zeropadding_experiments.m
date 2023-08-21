close all; clear; clc;

img=double(imread('2butterfly4096.jpg')); img = imresize(img,[256,256]);

figure(1);imagesc(img);title('original image');
figure(2);imagesc(log10(abs(fftshift(fft2(fftshift(img))))));title('fft');
figure(3);imagesc(crop(img,512,512));title('zeropadded image');
figure(4);imagesc(log10(abs(fftshift(fft2(fftshift(crop(img,512,512)))))));title('fft of zeropadded image -> higher freq range (less aliasing)');
figure(5);imagesc(log10(abs(crop(fftshift(fft2(fftshift(img))),512,512))));title('zeropadded fft');
figure(6);imagesc(abs(fftshift(ifft2(fftshift(crop(fftshift(fft2(fftshift(img))),512,512))))));title('zeropadded fft + ifft -> upscaled image');
figure(7);imagesc(imresize(img,[512,512]));title('upscaled image');
figure(8);imagesc(log10(abs(fftshift(fft2(fftshift(imresize(img,[512,512])))))));title('fft of upscaled image -> high freq range near zero');