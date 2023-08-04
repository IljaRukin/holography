function [F] = UnitTriangleFT(u,v)
% returns fourier transform of unit triangle with edges at (0,0),(0,1),(1,1)

%%%frequencies example
% M=512; %x samples
% N=512; %y samples
% Dm = 0.008; %x pixel pitch
% Dn = 0.008; %y pixel pitch
% dfx = 1/(M*Dm); %x frequency step
% dfy = 1/(N*Dn); %y frequency step
% [yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %grid
% u = dfx*xx; %x frequencies
% v = dfy*yy; %y frequencies

F = (exp(-2*pi*i*u)-1)./((2*pi)^2*u.*v) + (1-exp(-2*pi*i*(u+v)))./((2*pi)^2*v.*(u+v));

mask = (u==0).*(v==0);
ind = find(mask);
if numel(ind)>0
    F(ind) = 1/2;
end

mask = (u==0).*(v~=0);
ind = find(mask);
if numel(ind)>0
    F(ind) = (1-exp(-2*pi*i*v(ind)))./((2*pi*v(ind)).^2) - (i)./(2*pi*v(ind));
end

mask = (u~=0).*(v==0);
ind = find(mask);
if numel(ind)>0
    F(ind) = (exp(-2*pi*i*u(ind))-1)./((2*pi*u(ind)).^2) + (i*exp(-2*pi*i*u(ind)))./(2*pi*u(ind));
end

mask = (u==-v).*(v~=0);
ind = find(mask);
if numel(ind)>0
    F(ind) = (1-exp(2*pi*i*v(ind)))./((2*pi*v(ind)).^2) + (i)./(2*pi*v(ind));
end

end