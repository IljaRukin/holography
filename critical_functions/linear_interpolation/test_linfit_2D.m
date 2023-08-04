%fit: f=ax*x+ay*y+b
close all;clear;clc;

[x,y] = meshgrid(-2:0.2:3,-5:0.2:-1);
ax0=0.5; ay0=-0.2; b0=2;
f = ax0*x + ay0*y + b0 + 1.5*(rand(size(x))-0.5);
% w = ones(size(x));
w = rand(size(x));

w_bar = sum(w(:));
x_bar = sum(w(:).*x(:));
y_bar = sum(w(:).*y(:));
f_bar = sum(w(:).*f(:));
xx_bar = sum(w(:).*x(:).^2);
yy_bar = sum(w(:).*y(:).^2);
xy_bar = sum(w(:).*x(:).*y(:));
xf_bar = sum(w(:).*x(:).*f(:));
yf_bar = sum(w(:).*y(:).*f(:));

% ax = (yf_bar - f_bar*y_bar/w_bar)/(yy_bar-y_bar*y_bar/w_bar)*(y_bar*x_bar/w_bar-xy_bar)/(xx_bar-x_bar*x_bar/w_bar)/(1-(x_bar*y_bar/w_bar-xy_bar)*(y_bar*x_bar/w_bar-xy_bar)/(yy_bar-y_bar*y_bar/w_bar)/(xx_bar-x_bar*x_bar/w_bar)) + (xf_bar - f_bar*x_bar/w_bar)/(xx_bar-x_bar*x_bar/w_bar)/(1-(x_bar*y_bar/w_bar-xy_bar)*(y_bar*x_bar/w_bar-xy_bar)/(yy_bar-y_bar*y_bar/w_bar)/(xx_bar-x_bar*x_bar/w_bar));
% ay = (yf_bar - f_bar*y_bar/w_bar)/(xy_bar-x_bar*y_bar/w_bar)*(x_bar*x_bar/w_bar-xx_bar)/(xy_bar-y_bar*x_bar/w_bar)/(1-(y_bar*y_bar/w_bar-yy_bar)/(xy_bar-x_bar*y_bar/w_bar)*(x_bar*x_bar/w_bar-xx_bar)/(xy_bar-y_bar*x_bar/w_bar)) + (xf_bar - f_bar*x_bar/w_bar)/(xy_bar-y_bar*x_bar/w_bar)/(1-(y_bar*y_bar/w_bar-yy_bar)/(xy_bar-x_bar*y_bar/w_bar)*(x_bar*x_bar/w_bar-xx_bar)/(xy_bar-y_bar*x_bar/w_bar));
ax = (y_bar^2*xf_bar+xy_bar*w_bar*yf_bar+f_bar*x_bar*yy_bar-f_bar*xy_bar*y_bar-x_bar*y_bar*yf_bar-w_bar*xf_bar*yy_bar)/(x_bar^2*yy_bar+y_bar^2*xx_bar+xy_bar^2*w_bar-2*xy_bar*x_bar*y_bar-w_bar*xx_bar*yy_bar);
ay = (x_bar^2*yf_bar+xy_bar*w_bar*xf_bar+f_bar*y_bar*xx_bar-f_bar*xy_bar*x_bar-x_bar*y_bar*xf_bar-w_bar*xx_bar*yf_bar)/(x_bar^2*yy_bar+y_bar^2*xx_bar+xy_bar^2*w_bar-2*xy_bar*x_bar*y_bar-w_bar*xx_bar*yy_bar);
b = (f_bar - ax*x_bar - ay*y_bar)/w_bar;

% ax0*xx_bar + ay0*xy_bar + b0*x_bar - xf_bar
% ax0*xy_bar + ay0*yy_bar + b0*y_bar - yf_bar
% ax0*x_bar + ay0*y_bar + b0*w_bar - f_bar