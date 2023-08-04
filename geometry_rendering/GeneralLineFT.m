function [F] = LineFT(u,v,x1,x2,y1,y2)
% returns fourier transform of line segment between (x1,y1),(x2,y2)

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

%%%simple [-0.5,0]---[0.5,0]
% F = 1/(1i*2*pi) * sinc( (1)*u ) .* sinc( v/size(v,2) );

%%%simple + shifted [0,0]---[1,0]
% F = 1/(1i*2*pi) * sinc( (1)*u ) .* exp(-i*2*pi*(1/2)*u) .* sinc( v/size(v,2) );

%%%shifted + scaled [x1,0]---[x2,0]
% ax = (x2-x1);
% F = abs(ax)/(1i*2*pi) * sinc( ax*u ) .* exp(-i*2*pi*(ax/2+x1)*u) .* sinc( v/size(v,2) );

%%%shifted + scaled + sheared [x1,y1]---[x2,y2]
ax = (x2-x1);
ay = (y2-y1);
F = (abs(ax)+abs(ay))/(1i*2*pi) * sinc( ax*u+ay*v ) .* exp(-i*2*pi* ((ax/2+x1)*u+(ay/2+y1)*v) ) .* sinc( v/size(v,2) );

end