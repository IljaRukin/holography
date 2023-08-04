
M = 128;
N = 128;
x = single(linspace(-1,1,M));
y = single(linspace(-1,1,N));
%[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
[xx,yy] = meshgrid(x,y);

phi = mod(atan2(yy,xx),2*pi);
imagesc(phi);
colormap('hsv');colorbar('XTick',0:pi/2:2*pi,'XTickLabel',{'0','\pi/2','\pi','3\pi/2','2\pi'});axis xy;caxis([0,2*pi]);
