%fit: f=a*x+b
close all;clear;clc;

x =  -2:0.2:3;
a0=0.5; b0=2;
f = a0*x + b0 + 1.5*(rand(size(x))-0.5);
% w = ones(size(x));
w = rand(size(x));

w_bar = sum(w);
x_bar = sum(w.*x);
f_bar = sum(w.*f);
xx_bar = sum(w.*x.^2);
xf_bar = sum(w.*x.*f);

a = (w_bar.*xf_bar-x_bar.*f_bar)/(w_bar.*xx_bar-x_bar.^2);
b = (f_bar - a*x_bar)/w_bar;

% a0*xx_bar + b0*x_bar - xf_bar
% (f_bar - a0*x_bar)/w_bar - b0