close all; clear; clc;

%setup
N = 2^12;
lambda = 532e-6;

% a = 1; %mm (observed window width)
% x = single(linspace(-a,a,N)).';
% fs=N/(2*a);

Dn = 0.001;
x = (-N/2:N/2-1).';
fs = 1/Dn; %sampling frequency

%data points
z = -50;
u = exp(sign(z)*1i*2*pi/lambda*sqrt(x.^2+z^2));


%stereogramm
w=16;
% window = ones(w,1);
window = hann(w, "periodic");
hop = w/2;

tic
[S1, f, t] = stft(u, window, hop, [], fs); % use [] for default values
toc
figure(1);imagesc(fftshift(abs(S1),1));

tic
S2 = fftshift(fft(fftshift(reshape(u,N/w,w)),[],2));
toc
figure(2);imagesc(abs(S2));

% surf(t, f(1:end/2+1), 20*log10(abs(S1(1:end/2+1,:))));
% view(2);
% shading flat;
% xlabel('Time [sec]');
% ylabel('Frequency [Hz]');