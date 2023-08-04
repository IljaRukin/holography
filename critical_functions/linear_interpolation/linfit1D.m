function [a,b] = linfit1D(x,f,w)
%interpolate function linearly f=a*x+b
%with weights w for the importance of every datapoint
w_bar = sum(w);
x_bar = sum(w.*x);
f_bar = sum(w.*f);
xx_bar = sum(w.*x.^2);
xf_bar = sum(w.*x.*f);

a = (w_bar.*xf_bar-x_bar.*f_bar)/(w_bar.*xx_bar-x_bar.^2);
b = (f_bar - a*x_bar)/w_bar;
end

