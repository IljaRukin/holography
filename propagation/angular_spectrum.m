function E = angular_spectrum(U,zSlices,Dn,Dm,lambda,zeropad)
%propagate wavefield as angular spectrum in fourier space (Methode 5)
%input wavefield U consists of multiple planes with height/width/plane_nr of [N0,M0,nSlices].
%it is propagated by distances defined in zSLices to a SLM with pixel pitch
%(Dm,Dn) with ligth of wavelength lambda and returned as wavefield E.
%additionally zeropadding and antialiasing can be applied by setting the corresponding variable true.

%save size to crop output later
[N0,M0,~] = size(U);

%zeropad
wsize = [size(U,1),size(U,2),size(U,3)];
pad = (2.^(ceil(log2(wsize(1:2)))+zeropad) - wsize(1:2))./2;
U = cat(1,zeros(ceil(pad(1)),wsize(2),wsize(3)),U,zeros(floor(pad(1)),wsize(2),wsize(3)));
U = cat(2,zeros(size(U,1),ceil(pad(2)),wsize(3)),U,zeros(size(U,1),floor(pad(2)),wsize(3)));
[N,M,nSlices] = size(U);

%compute impulse response
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
dfx = 1/(M*Dm); dfy = 1/(N*Dn); %frequency steps = 1/SLM_width
freq2 = xx.^2*dfx^2 + yy.^2*dfy^2; %frequencies squared
mask = freq2<1/lambda^2; %mask for evanescent waves
k = sqrt( 1 - freq2*lambda^2.*mask );
%%%k = ( 1 - freq2*lambda^2/2.*mask ); %simplified sqrt
clear mask; clear freq2;

%propagate
E = zeros(N,M);
for iSlice = 1:nSlices
    fprintf('slice %i \n',iSlice);
    z = -zSlices(iSlice);
    ft_spherical = exp(1i*2*pi/lambda*z*k);
    E = E + fftshift(ifft2( (fft2(fftshift( U(:,:,iSlice) ))) .* fftshift(ft_spherical) ));
end

%crop & scale
E = crop(E,N0,M0);
%%%E = scaleValues(E,0,1);

end