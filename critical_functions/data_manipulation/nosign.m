function [x] = nosign(x)
%returns absolute value (without sign)
if isreal(x)
    x = sign(x).*x;
else
    x = abs(x);
end
end