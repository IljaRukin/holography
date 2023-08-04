
M = 128;
N = 128;
x = single(linspace(-1,1,M));
y = single(linspace(-1,1,N));
%[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
[xx,yy] = meshgrid(x,y);

color = zeros(N,M,3,'single');

%%%(1,1,0) --- (0,0,1)
% maskx = xx>0;
% val = maskx.*xx;
% pos = [1,1,0];
% for a = 1:3
%     if pos(a) > 0
%         color(:,:,a) = color(:,:,a) + pos(a)*val;
%     end
% end
% pos = [0,0,1];
% val = -(1-maskx).*xx;
% for a = 1:3
%     if pos(a) > 0
%         color(:,:,a) = color(:,:,a) + pos(a)*val;
%     end
% end
% 
% %%%(0,1,0.5) --- (1,0.5,0)
% masky = yy>0;
% val = masky.*yy;
% pos = [0,1,0.5];
% for a = 1:3
%     if pos(a) > 0
%         color(:,:,a) = color(:,:,a) + pos(a)*val;
%     end
% end
% pos = [1,0.5,0];
% val = -(1-masky).*yy;
% for a = 1:3
%     if pos(a) > 0
%         color(:,:,a) = color(:,:,a) + pos(a)*val;
%     end
% end

nosign = @(x) sign(x).*x;
foldback = @(x) nosign( (x<=pi).*x + (x>pi).*(2*pi-x) );

phi = mod(atan2(yy,xx),2*pi);
r = ((xx).^2+(yy).^2) .* (xx.^2+yy.^2 < 1);
r = r/max(r,[],'all');
color(:,:,1) = (1-r) + r.*min(max(2-3/pi*foldback(phi-0/3*pi),0),1);
color(:,:,2) = (1-r) + r.*min(max(2-3/pi*foldback(phi-2/3*pi),0),1);
color(:,:,3) = (1-r) + r.*min(max(2-3/pi*foldback(phi-4/3*pi),0),1);

imagesc(color)
colormap('hsv');colorbar('XTick',0:0.25:1,'XTickLabel',{'0','\pi/2','\pi','3\pi/2','2\pi'});axis xy;
