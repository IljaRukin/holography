function E = fourier_multiplication_antialias(U,zSlices,Dn,Dm,lambda,zeropad,antialias,NpixelX,NpixelY)
%propagate wavefield with convolution by multiplication in fourier space (Methode 2)
%input wavefield U consists of multiple planes with height/width/plane_nr of [N0,M0,nSlices].
%it is propagated by distances defined in zSLices to a SLM with pixel pitch
%(Dm,Dn) with ligth of wavelength lambda and returned as wavefield E.
%additionally zeropadding and antialiasing can be applied by setting the corresponding variable true.

%%% compared to simple "fourier_multiplication" numerical antialiasing was added

%save size to crop output later
[N0,M0,~] = size(U);

%zeropad
wsize = [size(U,1),size(U,2),size(U,3)];
pad = (2.^(ceil(log2(wsize(1:2)))+zeropad) - wsize(1:2))./2;
U = cat(1,zeros(ceil(pad(1)),wsize(2),wsize(3)),U,zeros(floor(pad(1)),wsize(2),wsize(3)));
U = cat(2,zeros(size(U,1),ceil(pad(2)),wsize(3)),U,zeros(size(U,1),floor(pad(2)),wsize(3)));
[N,M,nSlices] = size(U);

%coordinates
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
coord2 = xx.^2*Dm^2 + yy.^2*Dn^2; %SLM coordinates squared

%propagate
E = zeros(N,M);
mask = 1; %mask for antialiasing; init with 1 in case of no antialiasing
for iSlice = 1:nSlices
    fprintf('slice %i \n',iSlice);
    z = -zSlices(iSlice);
    if antialias == true
        %theta_x = asin(lambda/(2*Dm*NpixelX));
        %r_x = z*tan(theta_x);
        r_x = (z*lambda)/(2*Dm*NpixelX); %approximation
        %theta_y = asin(lambda/(2*Dn*NpixelY));
        %r_y = z*tan(theta_y);
        r_y = (z*lambda)/(2*Dn*NpixelY); %approximation
        mask = xx.^2*(Dm/r_x)^2 + yy.^2*(Dn/r_y)^2 < 1; %antialiasing mask
    end
    spherical = exp(1i*2*pi/lambda*sign(z)* sqrt( z^2 + coord2 ) ) .*mask;
    E = E + fftshift(ifft2( (fft2(fftshift( U(:,:,iSlice) ))) .* (fft2(fftshift(spherical))) ));
end

%crop & scale
E = crop(E,N0,M0);
%%%E = scaleValues(E,0,1);

end