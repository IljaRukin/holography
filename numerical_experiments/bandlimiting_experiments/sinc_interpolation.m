%even with sinc interpolation the number of samples in real space have to
%be equal to the number of samples in frequency space (a=1) !

%note:
%f0 = original data
%fsinc = sinc interpolated (banlimited) data
%flim = highly bandlimited data

close all;clear;clc;
addpath('../image_processing');
addpath('../propagate');
random_seed = 0;
rng(random_seed);

%samples
M = 64; %number of samples
bandlimit = M/2;
steps = 1; %has to be 1 to match signal: bandlimit = M*steps
% x = (1:M)*steps;
% x = (0:M-1)*steps;
x = (0:M-1)*steps-M/2;

%function
n = 1; % interpolate function
f0 = sin(0.5*x)+3;
% f0 = imresize( rand(1,M/n) ,[1,M]) +1;
% f0 = rand(1,M) +1;
% phase = 0;
% phase = imresize( rand(1,M/n) ,[1,M]);
% phase = rand(1,M);
phase = x.^2;
f0 = f0.*exp(i*phase);

%%%sinc interpolation
upscale = 4;
% xs = (0:M*upscale-1)*steps/upscale;
% xs = (0:M*upscale-1)*steps/upscale+1;
xs = (0:M*upscale-1)*steps/upscale+1-M/2;
[Ts,T] = ndgrid(xs,x);
fsinc = sinc(Ts - T)*f0.';

%foruier transform
F0 = fftshift(fft(fftshift(f0)));
Fsinc = fftshift(fft(fftshift(fsinc)));

%hard band limiting
Flim = crop(crop(Fsinc,bandlimit,1),M*upscale,1);
flim = fftshift(ifft(fftshift(Flim)));

figure(1);
hold on
plot(x,abs(f0),'bo');
plot(xs,abs(fsinc),'g-.');
plot(xs,abs(flim),'r:*');
legend('f0','fsinc','flim')
ylim([0,5]);
hold off

figure(2);
hold on
plot(x,abs(F0),'bo');
plot(xs,abs(Fsinc),'g-.');
plot(xs,abs(Flim),'r:*');
legend('F0','Fsinc','Flim')
hold off
