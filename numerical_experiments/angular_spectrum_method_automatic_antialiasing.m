%{
M = 2048; %rendered window y resolution
N = 2048; %rendered window x resolution
Dm = 0.008; %SLM y pixel pitch = hologram pixel pitch (except for fresnel propagation)
Dn = 0.008; %SLM x pixel pitch = hologram pixel pitch (except for fresnel propagation)
lambda = 0.0006328; %helium-neon
z = 50; %position of image planes
%}

M = 1024; %rendered window y resolution
N = 2048; %rendered window x resolution
Dm = 0.015; %SLM y pixel pitch = hologram pixel pitch (except for fresnel propagation)
Dn = 0.007; %SLM x pixel pitch = hologram pixel pitch (except for fresnel propagation)
lambda = 0.0005; %helium-neon
z = 100; %position of image planes

[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
coord2 = xx.^2*Dm^2 + yy.^2*Dn^2; %SLM coordinates squared

%theta_x = asin(lambda/(2*Dm));
%r_x = z*tan(theta_x);
r_x = (z*lambda)/(2*Dm); %approximation
%theta_y = asin(lambda/(2*Dn));
%r_y = z*tan(theta_y);
r_y = (z*lambda)/(2*Dn); %approximation
mask = xx.^2*(Dm/r_x)^2 + yy.^2*(Dn/r_y)^2 < 1; %antialiasing mask
spherical = exp(1i*2*pi/lambda*sign(z)* sqrt( z^2 + coord2 ) ) .*mask;

figure(1);imagesc(real(spherical));title('ideal aliasing');colorbar();

[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %discrete: k,l,m,n
dfx = 1/(M*Dm); dfy = 1/(N*Dn); %frequency steps = 1/SLM_width
freq2 = xx.^2*dfx^2 + yy.^2*dfy^2; %frequencies squared
k = sqrt( 1 - freq2*lambda^2 );
ft_spherical = exp(1i*2*pi/lambda*z* k );
spherical = fftshift(ifft2(fftshift(ft_spherical)));

figure(2);imagesc(real(spherical));title('automatic aliasing');colorbar();
