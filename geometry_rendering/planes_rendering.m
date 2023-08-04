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
zmin=-100; zmax=-80; %depth range in mm
% zmin=80; zmax=100; %depth range in mm
zSlices = linspace(zmin,zmax,nSlices); %position of image planes (distance to SLM)

%% load object volume slices
% ObjectName = 'OBJ_vol';
% obj = 'simple_objects.obj';
% wx = 1200; wy = 800;
% axis_remap = {'+y','+x','+z'};
% U = slice_vol_obj(obj,M,N,nSlices,wx,wy,axis_remap);
% U = sqrt(U);

%% load object surface slices
ObjectName = 'OBJ_surf';
obj = 'simple_objects.obj';
wx = 1200; wy = 800;
axis_remap = {'+y','+x','+z'};
U  = slice_surf_obj(obj,M,N,nSlices,wx,wy,axis_remap);
U = sqrt(U);

%% add initial random phase
RandomPhase = false;
if RandomPhase
    ObjectName = [ObjectName,'_random'];
    U = U .* exp(1i*2*pi*rand(N,M,nSlices));
    % U = U .*exp(1i*2*pi*imresize(rand(M/2,N/2,nSlices),2));
else
    ObjectName = [ObjectName,'_nonrandom'];
end

%% save object as gif
% Tframe = 0.1; %time a frame is displayed in seconds
% saveGIF(U,'./test.gif',Tframe);

%% plot object
figure(1);
[a2,a1,a3] = ind2sub(size(U),find(U));
ax = scatter(a1,a2,'b.');
set(gca,'XDir','reverse')
camroll(90);
xlabel('x');ylabel('y');
plot3(a1,a2,a3,'b.')
xlabel('x');ylabel('y');zlabel('z');
axis xy;

%% wavefield Propagation
%using antialias or zeropad can improve hologram quality, but slows down rendering
antialias = true;
zeropad = true;
tic
% E = angular_spectrum(U,-zSlices,Dn,Dm,lambda,zeropad);
E = angular_spectrum_occlusion(U,-zSlices,Dn,Dm,lambda,zeropad);
toc

%% tiling
% E = MMAtiling(E,32,32);
% E = SLMtiling(E,32,32);

%% adjust wavefield amplitude
E = E/max(abs(E(:)));

%% display phase
figure(2);imagesc(angle(E));colorbar();colormap(parula);axis("equal");axis xy;

%% save result
path = './WF/';
fname = [ObjectName,'_z',num2str(zSlices(1)),'_',num2str(zSlices(end)),'_nSlices',num2str(nSlices),'_lambda',num2str(lambda*1e+6),'_Dm',num2str(Dm*1e+3),'_Dn',num2str(Dn*1e+3),'_rng',num2str(random_seed)];
saveFPImage(E,[path,'WF_',fname,'.fp.img']);
% saveTTPAparams([path,'params_',fname,'.mat'], scaleValues(abs(E),0,1), angle(E), 0, 0, lambda, Dm, Dn);
% save([path,'E_',fname,'.mat'],'E');
