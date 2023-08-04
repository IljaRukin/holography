function [color] = ColorCodedDirection(I,xx,yy)

nosign = @(x) sign(x).*x;
foldback = @(x) nosign( (x<=pi).*x + (x>pi).*(2*pi-x) );

phi = mod(atan2(yy,xx),2*pi);
r = I.*(xx.^2+yy.^2);% .* (xx.^2+yy.^2 < 1);
r = r/max(r,[],'all');
color(:,:,1) = (1-r) + r.*min(max(2-3/pi*foldback(phi),0),1);
color(:,:,2) = (1-r) + r.*min(max(2-3/pi*foldback(phi-2/3*pi),0),1);
color(:,:,3) = (1-r) + r.*min(max(2-3/pi*foldback(phi-4/3*pi),0),1);

imagesc(color);
colormap('hsv');caxis([0,2*pi]);
colorbar('XTick',0:pi/2:2*pi,'XTickLabel',{'0','\pi/2','\pi','3\pi/2','2\pi'});
axis xy;axis('equal');

end

