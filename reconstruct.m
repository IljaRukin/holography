close all;clear;clc;

%% parameters
Dm = 0.008;
Dn = 0.008;
lambda = 0.000638;
z1 = -100; %-50;
% z2 = -50;

%% wavefield
filename = './results/WF_3D_cube_z-80_-100_nSlices5_lambda638_Dm8_Dn8_rng0.fp.img';
filename = 'E:/Aufnahmen/Analysis Hypothesen/WF/Butterfly_ConstantPhase_fullres_z-250_lambda638_Dm8_Dn8.fp.img';
E=loadFPImage(filename);
% [amp,piston,alphaX,alphaY]=loadTTPAparams([path,'params_',fname,'.mat'],lambda,Dm,Dn); E=amp.*exp(1i*( TTP2Phase(alphaX, alphaY, piston, 1, 1) ));
% E=load([path,'E_',fname,'.mat']);E=E.E;
[N,M,~] = size(E);

%% point source
% M=1024;N=1024;
% [yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
% xx = xx*Dm; yy = yy*Dn;
% E = exp(sign(z1)*1i*2*pi/lambda*sqrt(xx.^2+yy.^2+z1^2));

%% coordinates
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
xx = xx*Dm; yy = yy*Dn;

%% modify wavefield
%%% binary amplitude
%E = (sq2(E)>0.1^2) .*exp(1i*angle(E));
%%%phase only modulation
% E = exp(1i*angle(E));
%%%mirror array tiling
% E = MMAtiling(E,8,8);
% E = SLMtiling(E,8,8);

%% upsampling
upscale = 1; %upsampling factor
Dm = Dm/upscale; Dn = Dn/upscale;
M = M*upscale; N = N*upscale;
E_old = E;
E = zeros(N,M);
for m=1:upscale
    for n=1:upscale
        E(n:upscale:end,m:upscale:end)=E_old;
    end
end
clear E_old;

%% coordinates
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
xx = xx*Dm; yy = yy*Dn;

%% display phase
figure(1);imagesc(angle(E));colorbar();axis("equal");axis xy;
title('phase');

%% blazing
%%%blazing offset bo = z*tan(theta)
%%%with theta = atan(phi/(2*pi)*lambda/p))
%%%<=> phi = 2*pi/lambda*tan(theta)*p
%%%        = 2*pi/lambda*tan(theta)*xx
%%%phi = phase change between two pixels
%%%p = pixelpitch = Dm/Dn
% thetaX = asin(lambda/(2*Dm))/2; %blazing angle chosen as BW/2 (+ = converging)
% thetaY = asin(lambda/(2*Dm))/2; %blazing angle chosen as BW/2 (+ = converging)
% phiX = k/sin(thetaY); phiY = k/sin(thetaY);
% E = E.*exp(1i*2*pi/lambda*(xx*phiX));

%% propagate
antialias = true;
zeropad = true;
%%%E = convolution(E,[z1],Dn,Dm,lambda,antialias); %Methode 1
%%%E = fourier_multiplication(E,[z1],Dn,Dm,lambda,zeropad,antialias); %Methode 2
%%%object plane pixel pitch needs to be adjusted for fresnel propagation
% Dm=z1*lambda/(M*Dm);Dn=z1*lambda/(N*Dn);E = fresnel(E,[z1],Dn,Dm,lambda,zeropad); %Methode 3
%%%E = fresnel_scaled(E,[z1],Dn,Dm,lambda,zeropad); %Methode 4
E = angular_spectrum(E,[z1],Dn,Dm,lambda,zeropad); %Methode 5
%%%E = angular_spectrum_occlusion(E,[z1],Dn,Dm,lambda,zeropad);
%%%E = sommerfeld(E,[z1],Dn,Dm,lambda,zeropad,antialias);

%% lens
%%%phase
% f1 = 50; %focal length
% E = E .* exp(-1i*2*pi/lambda/(2*f1)*(xx.^2+yy.^2));

%% circular aperture
% D = 5;
% E = E .* ((xx.^2+yy.^2)<D^2);

%% rectangular aperture
%d = 200;
% xmin = d;
% xmax = M-d;
% ymin = d;
% ymax = N-d;

%%%blank out borders
% E(1:xmin,:) = 0;
% E(xmax:end,:) = 0;
% E(:,1:ymin) = 0;
% E(:,ymax:end) = 0;

%%%blank out middle
% E(xmin:xmax,ymin:ymax) = 0;

%% block left half
% E = E.*(xx>0);

%% propagate again
% antialias = true;
% zeropad = true;
%%%E = convolution(E,[z2],Dn,Dm,lambda,antialias); %Methode 1
%%%E = fourier_multiplication(E,[z2],Dn,Dm,lambda,zeropad,antialias); %Methode 2
% Dm=z2*lambda/(M*Dm);Dn=z2*lambda/(N*Dn);E = fresnel(E,[z2],Dn,Dm,lambda,zeropad); %Methode 3
%%%E = fresnel_scaled(E,[z2],Dn,Dm,lambda,zeropad); %Methode 4
% E = angular_spectrum(E,[z2],Dn,Dm,lambda,zeropad); %Methode 5
%%%E = angular_spectrum_occlusion(E,[z2],Dn,Dm,lambda,zeropad);
%%%E = sommerfeld(E,[z2],Dn,Dm,lambda,zeropad,antialias);

%% display result
figure(2);
% imagesc(abs(E)); %amplitude
imagesc(sq2(E)); %intensity
% minVal = -10; maxVal = 20; imagesc(min(max(log10(sq2(E)),minVal),maxVal)); %log10 intensity
colorbar();colormap(gray);axis("equal");axis xy;
title('propagated wavefield itensity');

% figure(3);
% imagesc(angle(E)); %phase
% colorbar();colormap(jet);axis("equal");axis xy;

%% lightfield
w = 64; %window size
LF = zeros(N+N/w+1,M+M/w+1,'double');
for m=1:floor(M/w)
    for n=1:floor(N/w)
        LF(w*(n-1)+1+n:w*n+n,w*(m-1)+1+m:w*m+m) = fftshift(fft2(fftshift(conj(E(w*(n-1)+1:w*n,w*(m-1)+1:w*m)))));
    end
end
LF = LF./max(max(abs(LF)));
val = 1.1;
LF(1:w+1:M+M/w+1,:)=val; LF(:,1:w+1:N+N/w+1)=val;
figure(4);imagesc((abs(LF))); %lightfield amplitude
colorbar();colormap(hot);axis("equal");axis xy;axis off;
title('lightfield');
