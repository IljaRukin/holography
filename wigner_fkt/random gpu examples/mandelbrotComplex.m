%compile: nvcc -ptx mandelbrotComplex.cu
%reset
close all; clear; clc;
dev = parallel.gpu.GPUDevice.select( 1 );

%data points
iterations = uint32(100);
Nx = uint32(1024*14);
Ny = uint32(1024*14);
numElements = Nx*Ny;

x_min = single(-2);
x_max = single(0.5);
x=gpuArray.linspace(x_min, x_max, Nx);

y_min = single(-1.2);
y_max = single(1.2);
y=gpuArray.linspace(y_min, y_max, Ny);

[xGrid, yGrid]=meshgrid(x,y);
z = xGrid + i*yGrid;
clear xGrid; clear yGrid; clear x: clear y;
count = gpuArray.zeros(Ny,Nx,'uint32');

kernel = parallel.gpu.CUDAKernel( 'mandelbrotComplex.ptx', 'mandelbrotComplex.cu' );
% Make sure we have sufficient blocks to cover all of the locations
kernel.ThreadBlockSize = [kernel.MaxThreadsPerBlock,1,1];
kernel.GridSize = [ceil(numElements/kernel.MaxThreadsPerBlock),1];

% Call the kernel
tic
count = feval( kernel, count, z, iterations, numElements );
toc

count = gather( count ); % Fetch the data back from the GPU   

imagesc(flipud(count));
colormap('jet');
colorbar();