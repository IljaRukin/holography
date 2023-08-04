%1D Wigner distribution: W(fx,x) with x=[-M/2,...,M/2-1]
%computed using shifts 2*[-M/2,...,M/2-1] which results in
%fx=
%  ^
%  |
%  fx  W(fx,y)
%  |
%  ---x--->
%compile: nvcc -ptx multOFshifts1D.cu
close all; clear; clc;
g = gpuDevice(1);
% coder.gpuConfig('mex');

%setup
N = 1024*4;
numElements = N*N;
lambda = 532e-6;
a = 1; %mm (observed window width)

%data points
%%%x = ndgrid(-N/2:N/2-1);
x = linspace(-a,a,N);

% wavefield = 1:N;
z = 10; %mm (distance) gültig für [1,infty]mm
u = exp(sign(z)*1i*2*pi/lambda*sqrt(x.^2+z^2)); %figure(4); imagesc(abs(angular_spectrum(U,z,2*a/M,2*a/M,lambda,true)));
% u = zeros(N,1)+1i*10^(-14); u(500:1000) = 1; u(3000:3500) = 1;
u = gpuArray(single(u));
output = gpuArray(complex(zeros(N,N,'single'))); %complex

kernel = parallel.gpu.CUDAKernel( 'multOFshifts1D.ptx', 'multOFshifts1D.cu' );
% Make sure we have sufficient blocks to cover all of the locations
kernel.ThreadBlockSize = [kernel.MaxThreadsPerBlock,1,1];
% kernel.GridSize = [ceil(numElements/kernel.MaxThreadsPerBlock),1]; %not optimized
kernel.GridSize = [ceil(numElements/2/kernel.MaxThreadsPerBlock),1]; %optimize: compute only half

% compute Wigner function
output = feval( kernel, u, output, N );
output(2:N/2,:) = conj( output(N:-1:N/2+2,:) ); %optimize = get other half by mirroring + complex conjugation
output = fftshift(fft(fftshift( output ),N,1));
W = gather( output );
reset(g);

fig1 = figure(1);imagesc(abs(W));colormap('hot');colorbar();movegui(fig1,[200 500]);axis xy;
fig2 = figure(2);imagesc(angle(W));colormap('jet');colorbar();movegui(fig2,[800 500]);axis xy;