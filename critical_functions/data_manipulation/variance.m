function [x]=variance(x)
%returns variance of input
x = sum(sq2( x(:) - avg(x(:)) ))/numel(x);
end