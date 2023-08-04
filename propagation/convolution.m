function E = convolution(U,zSlices,Dn,Dm,lambda,antialias)
%propagate wavefield with brute force convolution integral (Methode 1)
%input wavefield U consists of multiple planes with height/width/plane_nr of [N0,M0,nSlices].
%it is propagated by distances defined in zSLices to a SLM with pixel pitch
%(Dm,Dn) with ligth of wavelength lambda and returned as wavefield E.
%additionally zeropadding and antialiasing can be applied by setting the corresponding variable true.

%array size
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
        %theta_x = asin(lambda/(2*Dm));
        %r_x = z*tan(theta_x);
        r_x = (z*lambda)/(2*Dm); %approximation
        %theta_y = asin(lambda/(2*Dn));
        %r_y = z*tan(theta_y);
        r_y = (z*lambda)/(2*Dn); %approximation
        mask = xx.^2*(Dm/r_x)^2 + yy.^2*(Dn/r_y)^2 < 1; %antialiasing mask
    end
    spherical = exp(1i*2*pi/lambda*sign(z)* sqrt( z^2 + coord2 ) ) .*mask;
    E = E + conv2(U(:,:,iSlice),spherical,'same');
end

%crop & scale
%E = crop(E,N0,M0); %not needed, sinze no zeropadding implemented
%%%E = scaleValues(E,0,1);

end