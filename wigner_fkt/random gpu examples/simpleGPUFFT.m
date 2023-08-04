%reset
close all; clear; clc;
dev = parallel.gpu.GPUDevice.select( 1 );

%data points
Nx = uint32(1024*8);
Ny = uint32(1024*8);
numElements = Nx*Ny;
%[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);

f1 = randn([Nx,Ny],'single');
f2 = randn([Nx,Ny],'single','gpuArray');

%%%standard fft
tic
F1 = fft2(f1);
t = toc;
fprintf('simple fft calc time: %f.2 \n',t);

%%%gpuarray fft - first execution slow, consequent executions x10 faster
tic
F2 = fft2(f2);
t = toc;
fprintf('gpuarray fft calc time: %f.2 \n',t);
%F2 = gather(F2);

% tic
% F3 = arrayfun(ElementwiseFunction,f2);
% toc
% F3 = gather(F3);

%mex -setup:'C:\Program Files\MATLAB\R2018b\bin\win64\mexopts\msvc2015.xml' C
%check: coder.checkGpuInstall()
% cfg = coder.gpuConfig('mex');
% cfg.GpuConfig.EnableCUFFT = 1;
%%% codegen -config cfg -args {f2} fft2
%{
codegen does not work -> run GPU test: coder.checkGpuInstall()
stop in dos.m during execution to find compilation folder
edit: setEnv.bat
in: set LINKFLAGS=-m64 -shared -L"C:\Program Files\MATLAB\R2018b\extern\lib\win64\mingw64" -llibmx -llibmex -llibmat -llibmwlapack -llibmwblas -llibMatlabDataArray
remove options: -Wl,--no-undefined -static -lm
add to path: C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64
still cannot find: gpusimpletest_mex.mexw64.manifest
%}
% tic
% F4 = fft2_mex(f2);
% toc

tic
F5 = fft2(f2);
t = toc;
fprintf('cuda fft calc time: %f.2 \n',t);
