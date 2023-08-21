close all;clear;clc;
addpath('../interfacing');

Nslm = 1080;
Mslm = 1920;
lambda = 0.000638; offset = 0.75*2*pi; %wavelength + amplitude modulation phase offset
display_screen = 1; %computer screen number on which to display

%%%start camera
x = videoinput('gentl',1);
src = getselectedsource(x);
src.ExposureTime = 40000;
vidRes = x.VideoResolution;

%%%live-picture from camera
display_live = false;
if display_live
    f0 = figure(1);
    f0.ToolBar = 'none';
    f0.MenuBar = 'none';
    f0.NumberTitle = 'Off';
    f0.Name = 'My Preview Window';
    % Create the image object in which you want to display
    % the video preview data. Make the size of the image
    % object match the dimensions of the video frames.
    nBands = x.NumberOfBands;
    hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
    %%%Display the video data in your GUI.
    preview(x, hImage);
    set(gca,'position',[0 0 1 1],'Visible','off');
    movegui(f0,[-2200 0]);
end

[xx,yy]=meshgrid(-Mslm/2+1:Mslm/2,-Nslm/2+1:Nslm/2);
mask = (xx.^2+yy.^2<500^2);

phiRGB = zeros(Nslm,Mslm,3);
initphase = offset;

correctAmplitude = false;
if correctAmplitude && (exist('amp_correction.mat', 'file') == 2)
    amp_correct = load('./calibration/dPhi_SLM.mat');
    amp_correct = crop( amp_correct.amp_correct ,Nslm,Mslm);
    [initphase,~] = AmpMod_phases(amp_correct,offset);
end

N=128;
avg_amp = zeros(1,N);
max_amp = zeros(1,N);
for a=1:N
    addphase = 2*pi*a/N;
    phiRGB(:,:,1) = initphase + mask*addphase;
    phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
    pause(0.5);
    display_fullscreen(display_screen,phiRGB);
    frame = getsnapshot(x);
    pause(0.5);
    I = im2double(frame(300:700,400:900));
    avg_amp(a) = sum(sum(I))/numel(I);
    max_amp(a) = sum(sum(I>0.99));
end

fig1 = figure(1);plot((1:N)*2*pi/N + offset,avg_amp);
ylabel('amplitude');xlabel('phase');
print(gcf,'amp_mod_measurements.png','-dpng','-r300');
save('amp_mod_measurements.mat','avg_amp');

%fitting
[ampmin,xminp] = min(avg_amp);
xmaxp = xminp+round(N/2);
ampmax = avg_amp(xmaxp);
x1 = xminp:xmaxp;
y = avg_amp(x1);
x1 = x1*2*pi/N + offset;
ampcoeff = polyfit(y,x1,9); %polynomial fit
figure(2);
hold on
plot(y,x1,'o')
xx = ampmin:0.01:ampmax;
plot(xx,polyval(ampcoeff,xx))
plot(xx,offset-2*acos(sqrt(linspace(0,1,numel(xx))))+2*pi,'g-');
legend({'gemessen','interpoliert','theoretisch'},'Position',[0.2,0.7,0.1,0.1]);
xlabel('amplitude');ylabel('phase');
hold off
print(gcf,'.amp_mod_curve.png','-dpng','-r300');
amprange = [ceil(min(avg_amp)*100)/100,floor(max(avg_amp)*100)/100];
save('amp_mod_curve.mat','amprange','ampcoeff')

%%%close camera
if display_live
    close 'My Preview Window'
end
delete(x)
clear x;