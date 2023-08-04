function [ax,ay,b] = linfit2D(x,y,f,w)
%interpolate function linearly f=ax*x+ay*y+b
%with weights w for the importance of every datapoint
w_bar = sum(w(:));
x_bar = sum(w(:).*x(:));
y_bar = sum(w(:).*y(:));
f_bar = sum(w(:).*f(:));
xx_bar = sum(w(:).*x(:).^2);
yy_bar = sum(w(:).*y(:).^2);
xy_bar = sum(w(:).*x(:).*y(:));
xf_bar = sum(w(:).*x(:).*f(:));
yf_bar = sum(w(:).*y(:).*f(:));

ax = (y_bar^2*xf_bar+xy_bar*w_bar*yf_bar+f_bar*x_bar*yy_bar-f_bar*xy_bar*y_bar-x_bar*y_bar*yf_bar-w_bar*xf_bar*yy_bar)/(x_bar^2*yy_bar+y_bar^2*xx_bar+xy_bar^2*w_bar-2*xy_bar*x_bar*y_bar-w_bar*xx_bar*yy_bar);
ay = (x_bar^2*yf_bar+xy_bar*w_bar*xf_bar+f_bar*y_bar*xx_bar-f_bar*xy_bar*x_bar-x_bar*y_bar*xf_bar-w_bar*xx_bar*yf_bar)/(x_bar^2*yy_bar+y_bar^2*xx_bar+xy_bar^2*w_bar-2*xy_bar*x_bar*y_bar-w_bar*xx_bar*yy_bar);
b = (f_bar - ax*x_bar - ay*y_bar)/w_bar;

end

