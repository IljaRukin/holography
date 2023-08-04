function [f1] = display_fullscreen(screenNR,img)
%displays the image "img" fullscreen on display with number "screenNR"
%image must be of datatype double with values in interval [0,1]

screens = get(0,'MonitorPositions');
%img = crop(img,screens(4),screens(3));

f1 = figure(999); %'resize','off'
f1.Position = screens(screenNR,:);
f1.MenuBar = 'none';
f1.ToolBar = 'none';
f1.WindowState = 'fullscreen';
imagesc(img,[0,1]);
drawnow
axis xy
axis off
set(gca,'position',[0 0 1 1]) %'Visible','off'

end