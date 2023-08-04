function [x] = sq2(x)
%returns |x|^2 with efficient computation
if isreal(x)
    x = x.*x;
else
    x = real(x).^2+imag(x).^2;
end
end