close all; clear; clc;

% random_seed = 0;
% rng(random_seed);

intensity = @(x) x.*conj(x);
coinflip = @(x) round(rand(1,x))*2-1;

M = 256;
xx = -M/2:M/2-1;

% object_amplitude = zeros(1,M);
% object_amplitude(1:2:end) = 1;
% object_amplitude(2:2:end) = 0;
object_amplitude = (1:M)/M;
% imagesc(object_amplitude);colormap('gray');colorbar();

%% initial phase - iterative fourier-transform algorithm applied to computer holography (2)
bandwidth_mask = crop(ones(1,M/2),1,M); %_|-|_
% bandwidth_mask = min( horzcat(1:M,M:-1:1)/(M/2+1) , 1).'; %/-\
max_spectral_intensity = 1e+3;
Ez = object_amplitude.*exp(i*2*pi*rand(1,M));
for iter=1:100
    Ez = object_amplitude.*exp(i*angle(Ez));
    Ef = fftshift(fft(fftshift(Ez)));
    Ef = Ef.*bandwidth_mask;
    Ef = min( abs(Ef) , max_spectral_intensity ) .* exp(i*angle(Ef));
    Ez = fftshift(ifft(fftshift(Ef)));
end
Ef = fftshift(fft(fftshift(Ez)));

%upsample
aa = 2;
Ef = crop(Ef,1,M*aa);
Ez = fftshift(ifft(fftshift(Ef)));

figure(1);plot(abs(Ez));title('optimized bandlimited signal');
figure(2);plot(abs( fftshift(fft(fftshift(Ez))) )); title('fft of signal');
