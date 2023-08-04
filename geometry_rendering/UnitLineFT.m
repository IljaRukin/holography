function [F] = UnitLineFT(u,v,width)
% returns fourier transform of unit line segment between (0,0),(1,1)
%the line has width: width

%line [0,0]---[1,1]
F = 1/(1i*2*pi) * sinc( u+v ) .* exp(-i*2*pi* ((1/2)*u+(1/2)*v) ) .* sinc( width*(u-v) );

end