%2D Wigner distribution: W(fx,fy,x,y) with x=[-M/2,...,M/2-1] , y=[-N/2,...,N/2-1]
%computed using shifts 2*[-M/2,...,M/2-1];2*[-N/2,...,N/2-1] which results in
%fx= , fy=
%  ^
%  |  m,n=const.
%  x  W(m,n,x,y)
%  |
%  ---y--->
%  ^
%  |   m,n=const.
%  fx W(fx,fy,m,n)
%  |
%  ---fy--->
%compile: nvcc -ptx multOFshifts2Dscaled.cu
close all; clear; clc;
g = gpuDevice(1);
% coder.gpuConfig('mex');

%% setup
M = 2^6;
N = 2^6;
numElements = M*N*M*N;
lambda = 532e-6;
a = 1; %mm (observed window width)

%% data points
%%%x = ndgrid(-M/2:M/2-1);
x = single(linspace(-a,a,M));
y = single(linspace(-a,a,N));
Dm = 2*a/(M-1); Dn = 2*a/(N-1);
[x,y] = meshgrid(x,y);
z = -200; %mm (distance)
U = exp(sign(z)*1i*2*pi/lambda*sqrt(x.^2+y.^2+z^2)); %figure(4); imagesc(abs(angular_spectrum(U,z,2*a/M,2*a/M,lambda,true)));

%% compute Wigner function on GPU
tic
wavefield = gpuArray(U);
output = gpuArray(complex(zeros(M,N,M,N,'single'))); %W(fx,fy,x,y)
kernel = parallel.gpu.CUDAKernel( 'multOFshifts2D.ptx', 'multOFshifts2D.cu' );
kernel.ThreadBlockSize = [kernel.MaxThreadsPerBlock,1,1];
kernel.GridSize = [ceil(numElements/kernel.MaxThreadsPerBlock),1]; %not optimized
output = feval( kernel, wavefield, output, M, N );
output = fftshift(fft(fft(fftshift( conj( output ) ),M,1),N,2));
W = gather( output );
toc
%%%time: 0.5s

%% alternative: compute Wigner function on CPU
% tic
% W = complex(zeros(M,N,M,N,'single'));
% temp1 = complex(zeros(M,N,'single'));
% temp2 = complex(zeros(M,N,'single'));
% for fy=1:N
%     for fx=1:M
%         temp1(:,:)=0; temp2(:,:)=0;
%         %W(fx,fy,x,y)
%         x_=-floor(fx-1-M/2); y_=-floor(fy-1-N/2);
%         %%%U(fx,fy,x+x_,y+y_) - x+x_=[0...M]+[-M/2...M/2-1]
%         temp1(max(1,1-x_):min(M,M-x_),max(1,1-y_):min(N,N-y_)) = U(max(1,1+x_):min(M,M+x_),max(1,1+y_):min(N,N+y_));
%         %%%U(fx,fy,x-x_,y-y_) - x-x_=[0...M]-[-M/2...M/2-1]
%         temp2(max(1,1+x_):min(M,M+x_),max(1,1+y_):min(N,N+y_)) = conj(U(max(1,1-x_):min(M,M-x_),max(1,1-y_):min(N,N-y_)));
%         W(fx,fy,:,:) = temp1.*temp2;
%     end
% end
% W = fftshift(fft(fft(fftshift( W ),N,2),M,1));
% toc
% %%time: 11s

%% calculate information subsets to compress 4D lightfield into 2D color-coded image

%%%average local pixel intensities
% avg = mean(abs(W),[1 2]);
% avg = squeeze(avg);%reshape(avg,N,M);

%%%average frequency intensities
% avg = mean(abs(W),[3 4]);
% avg = squeeze(avg);%reshape(avg,N,M);

%%% maximum frequencies
[ymax, fy] = max(mean(abs(W),2),[],1); %value and index of maximum frequency in x direction
[xmax, fx] = max(mean(abs(W),1),[],2); %value and index of maximum frequency in y direction
xmax = squeeze(xmax);%reshape(xmax,N,M);
ymax = squeeze(ymax);%reshape(ymax,N,M);
fx = squeeze(fx);%reshape(fx,N,M);
fy = squeeze(fy);%reshape(fy,N,M);
peak = sqrt(xmax.^2 + ymax.^2); %amplitude of maximum frequency
fig1=figure(1); maxFdir = ColorCodedDirection(peak,-(M/2-fx),-(N/2-fy));
ticks=(0:2*floor(M/2*Dm)*2)/2/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn)*2)/2/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
fname = './wigner_dominant_frequency.png';
% % % --- save plot ---
print(gcf,fname,'-dpng','-r300');
% img = imread(fname); imwrite(img(70:end-73,133:end-140,:),fname); %cropping
% % % --- save array ---
imwrite(maxFdir,jet,[fname(1:end-4),'_data',fname(end-3:end)],'PNG');
title('Wigner Distribution frequency Maxima Direction');movegui(fig1,[50 570]);

%% stitch lightfield together
W = abs(W); W = W/max(W(:));
W = uint8(W*254+1);
val = 0;
W(1,:,:,:)=val; W(:,1,:,:)=val; W(M,:,:,:)=val; W(:,N,:,:)=val;
W = reshape(permute(W,[1,3,2,4]),M^2,N^2);
fig2=figure(2);imagesc(W);colormap(vertcat([0,0,0],hot(255)));axis xy;axis('equal');axis off;
% fig2=figure(2);imagesc(W(16*M:M^2-16*M,16*N:N^2-16*N));colormap(vertcat([0,0,0],hot(255)));axis xy;axis off;
% fig2.WindowState = 'fullscreen';
fname = './wigner_lightfield.png';
% % % --- save plot ---
print(gcf,fname,'-dpng','-r1200');
% img = imread(fname); imwrite(img(70*4:end-(73+50)*4,(133+50)*4:end-140*4,:),fname); %cropping
% % % --- save array ---
imwrite(W,vertcat([0,0,0],hot(255)),[fname(1:end-4),'_data',fname(end-3:end)],'PNG');
title('Lightfield from Wigner Distribution');movegui(fig2,[650 570]);

%% compute 2D STFT
w = 8;
% fDc_x = floor(ROI_size_x/2)+1; fDc_y = floor(ROI_size_y/2)+1; %center of fourier domain
LF = zeros(M+M/w+1,N+N/w+1,'double');
for m=1:floor(M/w)
    for n=1:floor(N/w)
        LF(w*(n-1)+1+n:w*n+n,w*(m-1)+1+m:w*m+m) = fftshift(fft2(fftshift(conj(U(w*(n-1)+1:w*n,w*(m-1)+1:w*m)))));
    end
end
LF = abs(LF);
LF = LF/max(LF(:));
LF = uint8(LF*254+1);
val = 0;
LF(1:w+1:M+M/w+1,:)=val; LF(:,1:w+1:N+N/w+1)=val;
fig3=figure(3);imagesc(LF);colormap(vertcat([0,0,0],hot(255)));axis xy;axis('equal');axis off; colorbar();
fname = './STFT_lightfield.png';
% % % --- save plot ---
print(gcf,fname,'-dpng','-r300');
% img = imread(fname); imwrite(img(70:end-(73+50),(133+50):end-140,:),fname); %cropping
% % % --- save array ---
imwrite(LF,vertcat([0,0,0],hot(255)),[fname(1:end-4),'_data',fname(end-3:end)],'PNG');
title('STFT Lightfield');movegui(fig3,[1250 570]);

%% display one slice for constant y(n),fy(n)
% n = floor(N/2)+1;
% fn = floor(fN/2)+1;
% 
% fig1 = figure(1);
% imagesc(abs(reshape(W(:,fn,:,n),fM,M)));
% colormap('hot');
% colorbar();
% movegui(fig1,[200 570]);
% 
% fig2 = figure(2);
% imagesc(angle(reshape(W(:,fn,:,n),fM,M)));
% colormap('jet');
% colorbar();
% movegui(fig2,[800 570]);

%% display one slice for constant x(m),fx(m)
% m = floor(M/2)+1;
% fm = floor(fM/2)+1;
% 
% fig1 = figure(1);
% imagesc(abs(reshape(W(fm,:,m,:),fN,N)));
% colormap('hot');
% colorbar();
% movegui(fig1,[200 570]);
% 
% fig2 = figure(2);
% imagesc(angle(reshape(W(:,fm,:,m),fN,N)));
% colormap('jet');
% colorbar();
% movegui(fig2,[800 570]);

%% loop over slices for constant x,y

% for a=1:M
% figure(a+1);imagesc(abs(reshape(W(:,:,a,a),M,M)));colormap('hot');
% end

reset(g);