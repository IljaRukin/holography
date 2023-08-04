%compile: mexcuda cudafft.cu

mexcuda -I"C:\ProgramData\NVIDIA Corporation\CUDA Samples\v9.1\common\inc" -I"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.1\include" -L"C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.1\lib\x64" -l"cuda" -l"cudart" -l"cudadevrt" -l"cufft" cuda_fft.cu
%cufft is not linked properly

%data points
M = 256; N = 256;
numElements = M*N;

data = randn([M,N],'single','gpuArray');

% Call the kernel
tic
d_vx = cudafft( data );
toc
d_vx = gather(d_vx) 

imagesc(flipud(d_vx));
colormap('jet');
colorbar();