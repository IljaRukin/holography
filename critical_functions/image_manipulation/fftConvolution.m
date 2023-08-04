function [w] = fftConvolution(u,v,zeropad)
% convolve u and v of same size by multiplication in fourier space
[N,M,~] = size(u);
wsize = [size(u,1),size(u,2),size(u,3)];
pad = (2.^(ceil(log2(wsize(1:2)))+zeropad) - wsize(1:2))./2;
%%%zeropad u
u = cat(1,zeros(ceil(pad(1)),wsize(2),wsize(3)),u,zeros(floor(pad(1)),wsize(2),wsize(3)));
u = cat(2,zeros(size(u,1),ceil(pad(2)),wsize(3)),u,zeros(size(u,1),floor(pad(2)),wsize(3)));
%%%zeropad v
v = cat(1,zeros(ceil(pad(1)),wsize(2),wsize(3)),v,zeros(floor(pad(1)),wsize(2),wsize(3)));
v = cat(2,zeros(size(v,1),ceil(pad(2)),wsize(3)),v,zeros(size(v,1),floor(pad(2)),wsize(3)));
%fourier multiplication
w = fftshift(ifft2( (fft2(fftshift( u ))) .* (fft2(fftshift( v ))) ));
w = crop(w,N,M);
end

