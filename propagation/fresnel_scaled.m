function E = fresnel_scaled(U,zSlices,Dn,Dm,lambda,zeropad)
%propagate wavefield with scaled fresnel transform (Methode 4)
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

%indices % coordinates
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
coord2 = xx.^2*Dm^2 + yy.^2*Dn^2; %SLM coordinates squared

%propagate
E = zeros(N,M);
for iSlice = 1:nSlices
    fprintf('slice %i \n',iSlice);
    z = -zSlices(iSlice); %distance
    Dx = z*lambda/(M*Dm); %virtual window x pixel pitch
    Dy = z*lambda/(N*Dn); %virtual window y pixel pitch
    
    %adjust virtual coordinates by a,b to be equal to SLM coordinates
    a = Dm/Dx; b = Dn/Dy;
    Dx = Dm; Dy = Dn;

    %direct implementation from equation
%     exp1 = exp(1i*pi/(lambda*z) * (xx.^2*Dm^2 + yy.^2*Dn^2));
%     exp2 = exp(1i*pi/(lambda*z) * (xx.^2*Dx^2 + yy.^2*Dy^2));
%     exp3 = exp(1i*pi * (a/M*xx.^2 + b/N*yy.^2));
%     E = E + exp1 .* conj(exp3) .* fftshift(ifft2( fft2(fftshift( U(:,:,iSlice) .* exp2 .* conj(exp3) )) .* fft2(fftshift( exp3 )) ));
    
    %faster implementation
    if Dm==Dn
        exp3 = exp(1i*pi *a/M/(Dm^2) *coord2);
        exp1 = exp(1i*pi *(1/(lambda*z)-a/M/(Dm^2)) *coord2);
        E = E + exp1 .* fftshift(ifft2( fft2(fftshift( U(:,:,iSlice) .* exp1 )) .* fft2(fftshift( exp3 )) ));
    else
        exp3 = exp(1i*pi * (a/M*xx.^2 + b/N*yy.^2));
        exp1 = exp(1i*pi/(lambda*z)*coord2) .* conj(exp3);
        E = E + exp1 .* fftshift(ifft2( fft2(fftshift( U(:,:,iSlice) .* exp1 )) .* fft2(fftshift( exp3 )) ));
    end
    
end

%crop & scale
E = crop(E,N0,M0);
%%%E = scaleValues(E,0,1);

end