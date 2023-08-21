close all; clear; clc;

%% parameters
% param = 1; %constant phase
% param = 2; %quadratic phase
param = 3; %random phase

%% setup
subsample = 1; %subsample for high quality reconstruction
Dn = 0.008/subsample; %pixel pitch
N = 2048*subsample;
%E_line = zeros(N);
Nz = 200; %number of depth-slices
distances = linspace(1,Nz,Nz); %depth range in mm
lambda = 0.0006328;
z = 50;

%% example wavefield
morse = char("-... .. .- ...");
cmap = containers.Map;
cmap('-')=[1,1,1,1,1,1];
cmap('.')=[0,0,1,1,0,0];
cmap(' ')=[0,0,0,0,0,0];
morsecode = [];
for m=morse
    morsecode = [morsecode,cmap(m)];
end
zeropad = (2^(ceil(log2(numel(morsecode)))+1)-numel(morsecode))/2;
morsecode = cat(1,zeros(ceil(zeropad),1),reshape(morsecode,[numel(morsecode),1]),zeros(floor(zeropad),1));
upscale = floor( (N/subsample) /numel(morsecode));
E_line = zeros( (N/subsample) ,1);
for n=1:upscale
    E_line(n:upscale:end) = morsecode;
end

%% add initial phase
xx = ndgrid(- (N/subsample) /2: (N/subsample) /2-1);
if param==2
% 	E_line = E_line.*exp(-1i*pi/N*(xx).^2);
    E_line = E_line.*exp(-1i*pi/(lambda*z+N*(Dn*subsample)^2)*(xx).^2);
elseif param==3
	E_line = E_line.*exp(1i*2*pi*rand( (N/subsample) ,1));
end

%% upscale again
temp = E_line;
upscale = floor(N/numel(temp));
E_line = zeros(N,1);
for n=1:upscale
    E_line(n:upscale:end) = temp;
end
clear temp;

%% propagate E_line
E_D = angular_spectrum( E_line ,-z,Dn,Dn,lambda,false);
clear E_line;

%% upscale wavefield
N = N*n; Dn = Dn/n;
E_line = zeros(N,1);
for n=1:n
    E_line(n:upscale:end) = E_D;
end

%% pre-compute impulse response
xx = ndgrid(-N/2:N/2-1); %discrete: k,l,m,n
dfx = 1/(N*Dn); %frequency steps = 1/SLM_width
freq2 = xx.^2*dfx^2; %frequencies squared
mask = freq2<1/lambda^2; %mask for evanescent waves
k = sqrt( 1 - freq2*lambda^2.*mask );
%impulse response for propagation: slice to slice
% z = distances(2)-distances(1);
% ft_spherical = exp(1i*2*pi/lambda*z* k );

%% propagate
E = zeros(N,Nz);
E(:,1) = E_line;
for n=1:Nz
    %%%impulse response for propagation from z=0
    z = distances(n)-distances(1);
    ft_spherical = exp(-1i*2*pi/lambda*z* k );

    %propagate from z=0
    E(:,n+1) = fftshift(ifft2( (fft2(fftshift( E(:,1) ))) .* fftshift(ft_spherical) ));

    %propagate from slice to slice
%     E(:,n) = fftshift(ifft2( (fft2(fftshift( E(:,n-1) ))) .* fftshift(ft_spherical) ));
end

%% display and save result
I = sq2(E);
I = I/max(I(:));
I = log10(I);
figure(1);imagesc(I);colormap(jet(256));colorbar();caxis([-3,0]);
xlabel('Abstand in mm','interpreter','latex');ylabel('Breite in µm','interpreter','latex');
ticks=(0:50:Nz); xticks(ticks+1);xticklabels(ticks);
ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn))
if param==1
    fname = './lightpath_constantPhase.png';
elseif param==2
 	fname = './lightpath_quadraticPhase.png';
elseif param==3
 	fname = './lightpath_randomPhase.png';
end
% imwrite(I/max(I)*255,jet(256),fname,'PNG');
print(gcf,fname,'-dpng','-r300');
img = imread(fname); imwrite(img(70:1290,60:1610,:),fname); %cropping