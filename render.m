close all;clear;clc;
random_seed = 0;
rng(random_seed);

%% setup
%all units are in mm
%matricies are structured as: (y/N/Dn,x/M/Dm,z), where y/N/Dn=vertial and x/M/Dm=horizontal direction
M = 2048; %rendered window x resolution
N = 2048; %rendered window y resolution
Dm = 0.008; %SLM x pixel pitch = hologram pixel pitch (except for fresnel propagation)
Dn = 0.008; %SLM y pixel pitch = hologram pixel pitch (except for fresnel propagation)
lambda = 0.000638; %wavelength

% z0 = M*Dm^2/lambda; %distance for 1:1 scaling with fresnel propagation
nSlices = 10; %number of image planes
zmin = 50; zmax = 100; %plane distances to SLM (negative = virtual)
zSlices = linspace(zmin,zmax,nSlices); %position of image planes (distance to SLM)

%% load object slices

%%% point source
% ObjectName = 'point_source';
% U = zeros(N,M,1);
% U(M/2,N/2) = 1;

%%% 3D cube
% ObjectName = '3D_cube';
% dCubeX = 700; dCubeY = 400; edgeWidth = 5; fb_offset = 200;
% U = wire_cube(M,N,nSlices,dCubeX,dCubeY,edgeWidth,fb_offset);

%%% BIAS logo
% ObjectName = '2D_bias';
% nSlices = 1;
% zSlices = zSlices(1);
% U = imread('BIAS.png');
% %%% U = imread('nurlogo_sw_1000.png');
% %%%U = imread('bias_logo_big.png');
% % % U = imresize(U,0.1);
% U = crop(im2double(U(:,:,1)),N,M);

%%% BIAS on the bottom
% ObjectName = 'BIAS_bottom';
% U = zeros(N,M,nSlices);
% I = imread('B_bottom.png');
% U(:,:,1) = U(:,:,1) + crop(im2double(I(:,:,1)),N,M);
% I = imread('I_bottom.png');
% U(:,:,2) = U(:,:,2) + crop(im2double(I(:,:,1)),N,M);
% I = imread('A_bottom.png');
% U(:,:,3) = U(:,:,3) + crop(im2double(I(:,:,1)),N,M);
% I = imread('S_bottom.png');
% U(:,:,4) = U(:,:,4) + crop(im2double(I(:,:,1)),N,M);
% U(1230:end,730:1310,:) = U(1230:end,730:1310,:) .* exp(1i*2*pi*rand(N+1-1230,1310-730+1,nSlices));

%%% cube + BIAS
% % % ObjectName = 'BIAS_rect';
% % % dCubeX = 600; dCubeY = 400; edgeWidth = 10; fb_offset = 200;
% % % U = wire_cube(M,N,nSlices,dCubeX,dCubeY,edgeWidth,fb_offset);
% % % U = circshift(U,-120,1);
% % % I = imread('B_bottom.png');
% % % U(:,:,1) = U(:,:,1) + crop(im2double(I(:,:,1)),N,M);
% % % I = imread('I_bottom.png');
% % % U(:,:,4) = U(:,:,4) + crop(im2double(I(:,:,1)),N,M);
% % % I = imread('A_bottom.png');
% % % U(:,:,7) = U(:,:,7) + crop(im2double(I(:,:,1)),N,M);
% % % I = imread('S_bottom.png');
% % % U(:,:,10) = U(:,:,10) + crop(im2double(I(:,:,1)),N,M);
% % % % % % I = imread('BIAS_bottom.png');
% % % % % % U(:,:,1) = U(:,:,1) + crop(im2double(I(:,:,1)),N,M);
% % % U(1230:end,730:1310,:) = U(1230:end,730:1310,:) .* exp(1i*2*pi*rand(N+1-1230,1310-730+1,nSlices));

%%% image of two triangles
% ObjectName = 'triangles';
% U = flipud(im2double(imread('two_triangles.png')));
% U = U(:,:,1:2);
% zSlices = [-100,-150];
% nSlices = 1;

%%% images
nSlices = 1; zSlices = [-100]; %position
% image is alsways first downsampled to M0xN0 and upsampled later to MxN to keep resolution comparable and smooth it in case of upsampling
U=double(imread('2butterfly4096.jpg')); imgname='Butterfly';
% U=double(sum(imread('USAF-1951_cutout.png'),3)); U=scaleValues(-U,0,1); imgname='USAF_1961';
% U=double(imread('pirate.tiff')); U=crop(U,N0,M0); imgname='PirateMen';
[Nimg,Mimg]=size(U); U = flipud(crop(scaleValues(imresize(U,M/Mimg),0,1),N,M));
%%% add sizebar
% % % if ~strcmp(imgname,'One_Point')
% % %     sizebar = imread('sizebar2mm.png'); sizebar = flipud(scaleValues(imresize(sum(double(sizebar),3),Dm/Dm0),0,0.8));
% % %     U((end-1024)/2+1:(end-1024)/2+size(sizebar,1),(end+Mslm)/2-size(sizebar,2)+1:(end+Mslm)/2) = sizebar;
% % % end

% Mslm=1920; Nslm=1080; U = crop(crop(U,Nslm,Mslm),N,M); %set outside of SLM to zero
U = sqrt(U);

%% set initial phase
% constante phase
U = U;
ObjectName = [ObjectName,'_constant'];
% random phase
U = U.*exp(1i*2*pi*rand(N,M,nSlices));
ObjectName = [ObjectName,'_random'];
% random interpolated phase
for n=nSlices
    U(:,:,n) = U(:,:,n).*exp(1i*2*pi*imresize(rand(N/2,M/2),2));
end
ObjectName = [ObjectName,'_randominterpolated'];

%% save object as gif
% Tframe = 0.1; %time a frame is displayed in seconds
% saveGIF(U,'./test.gif',Tframe);

%% plot object
% figure(1);
% [a1,a2,a3] = ind2sub(size(U),find(U));
% ax = scatter(a1,a2,'b.');
% set(gca,'XDir','reverse')
% camroll(90);
% xlabel('x');ylabel('y');
% plot3(a1,a2,a3,'b.')
% xlabel('x');ylabel('y');zlabel('z');
% axis xy;

%% magnification by lens
% m = 4; %magnification factor, if negative => virual image
% f1 = 30; %focal length
% [U,zSlices] = magnify_by_1lens(U,zSlices,m,f1);

%% wavefield Propagation
%using antialias or zeropad can improve hologram quality, but slows down rendering
antialias = true;
zeropad = true;
tic
% E = convolution(U,-zSlices,Dn,Dm,lambda,antialias); %Methode 1
% E = fourier_multiplication(U,-zSlices,Dn,Dm,lambda,zeropad,antialias); %Methode 2
% E = fresnel(U,-zSlices,Dn,Dm,lambda,zeropad); %Methode 3
% E = fresnel_scaled(U,-zSlices,Dn,Dm,lambda,zeropad); %Methode 4
E = angular_spectrum(U,-zSlices,Dn,Dm,lambda,zeropad); %Methode 5
% E = angular_spectrum_occlusion(U,-zSlices,Dn,Dm,lambda,zeropad);
% E = sommerfeld(U,-zSlices,Dn,Dm,lambda,zeropad,antialias);
toc

%% amplitude enncoding before TTP-MMA regression
% full amplitude
E0 = E0;
% double Phase - vertical resolution 2x reduced / horizontal resolution unchanged
phi = zeros(N,M);
phi(1:2:end,:) = angle(E0(1:2:end,:)) + acos( abs(E0(1:2:end,:)) );
phi(2:2:end,:) = angle(E0(1:2:end,:)) - acos( abs(E0(1:2:end,:)) );
E0 = exp(1i*phi);
% single Phase
signum = ( 1-2*(real(E0)<0) ) .* ( 1-2*rem((1:M)+(1:N).',2) );
phi = angle(E0) + signum.*acos(abs(E0));
E0 = exp(1i*phi);
% bidirectional error diffusion
rmask = [[0,0,7/16].',[3/16,5/16,1/16].'].';
lmask = fliplr(rmask);
for yp=1:1:N-1
    if rem(yp,2)==0
        for xp = 2:1:M-1
            Ep = exp(1i*angle(E0(yp,xp))); %wavefield at (xp,yp) without amplitude
            E0(yp:yp+1,xp-1:xp+1) = E0(yp:yp+1,xp-1:xp+1) + (E0(yp,xp)-Ep).*rmask; %diffuse error
            E0(yp,xp) = Ep; %remove amplitude
        end
            else
        for xp = M-1:-1:2
            Ep = exp(1i*angle(E0(yp,xp))); %wavefield at (xp,yp) without amplitude
            E0(yp:yp+1,xp-1:xp+1) = E0(yp:yp+1,xp-1:xp+1) + (E0(yp,xp)-Ep).*lmask; %diffuse error
            E0(yp,xp) = Ep; %remove amplitude
        end
    end
end

%% TTP-MMA regression
Npixel=4;
NpixelX = Npixel; NpixelY = Npixel;
E0 = MMAtiling(E0,NpixelX,NpixelY);
%E0 = SLMtiling(E0,NpixelX,NpixelY);

%% amplitude enncoding after TTP-MMA regression
NmirrorX = floor(M/NpixelX);
NmirrorY = floor(N/NpixelY);
% low-res amplitude array
tiled = reshape(mean(mean(reshape( abs(E0) ,NpixelY,NmirrorY,NpixelX,NmirrorX),3),1),NmirrorY,NmirrorX);
% full amplitude
tiled = abs(tiled);
% double Phase - vertical resolution 2x reduced / horizontal resolution unchanged
phi = zeros(N/NpixelY,M/NpixelX);
%phi(1:2:end,:) = angle(tiled(1:2:end,:)) + acos( abs(tiled(1:2:end,:)) ); %line encoding
%phi(2:2:end,:) = angle(tiled(1:2:end,:)) - acos( abs(tiled(1:2:end,:)) ); %line encoding
ampli = 0.5*( tiled(1:2:end,:) + tiled(2:2:end,:) );
phi(1:2:end,1:2:end) = + acos( ampli(:,1:2:end) ); %checker board encoding
phi(1:2:end,2:2:end) = - acos( ampli(:,2:2:end) ); %checker board encoding
phi(2:2:end,1:2:end) = - acos( ampli(:,1:2:end) ); %checker board encoding
phi(2:2:end,2:2:end) = + acos( ampli(:,2:2:end) ); %checker board encoding
tiled = exp(1i*phi);
% single Phase
signum = ( 1-2*(real(tiled)<0) ) .* ( 1-2*rem((1:M/NpixelX)+(1:N/NpixelY).',2) );
phi = angle(tiled) + signum.*acos(abs(tiled));
tiled = exp(1i*phi);
% bidirectional error diffusion
rmask = [[0,0,7/16].',[3/16,5/16,1/16].'].';
lmask = fliplr(rmask);
for yp=1:1:N/NpixelY-1
    if rem(yp,2)==0
        for xp = 2:1:M/NpixelX-1
            Ep = exp(1i*angle(tiled(yp,xp))); %wavefield at (xp,yp) without amplitude
            tiled(yp:yp+1,xp-1:xp+1) = tiled(yp:yp+1,xp-1:xp+1) + (tiled(yp,xp)-Ep).*rmask; %diffuse error
            tiled(yp,xp) = Ep; %remove amplitude
        end
            else
        for xp = M/NpixelX-1:-1:2
            Ep = exp(1i*angle(tiled(yp,xp))); %wavefield at (xp,yp) without amplitude
            tiled(yp:yp+1,xp-1:xp+1) = tiled(yp:yp+1,xp-1:xp+1) + (tiled(yp,xp)-Ep).*lmask; %diffuse error
            tiled(yp,xp) = Ep; %remove amplitude
        end
    end
end

%% expand phase array, which was calculated by encoding the amplitude
encoded_amplitude = zeros(NmirrorY*NpixelY,NmirrorX*NpixelX);
for m=1:NpixelX
    for n=1:NpixelY
        encoded_amplitude(n:NpixelY:end,m:NpixelX:end)=tiled;
    end
end
%% combine (in phase) encoded amplitude with the phase of the wavefield (E0mma)
E0 = encoded_amplitude.*exp(1i*angle(E0));
clear encoded_amplitude;

%% adjust wavefield amplitude
E = E/max(abs(E(:)));

%% reduce resolution to the resolution of the SLM
%E0 = crop(E0,Nslm,Mslm);

%% display phase
figure(2);imagesc(angle(E));colorbar();colormap(parula);axis("equal");axis xy;

%% save result
path = './results/';
fname = [ObjectName,'_z',num2str(zSlices(1)),'_',num2str(zSlices(end)),'_nSlices',num2str(nSlices),'_lambda',num2str(lambda*1e+6),'_Dm',num2str(Dm*1e+3),'_Dn',num2str(Dn*1e+3),'_rng',num2str(random_seed)];
% saveFPImage(E,[path,'WF_',fname,'.fp.img']);
% saveTTPAparams([path,'params_',fname,'.mat'], scaleValues(abs(E),0,1), angle(E), 0, 0, lambda, Dm, Dn);
% save([path,'E_',fname,'.mat'],'E');
