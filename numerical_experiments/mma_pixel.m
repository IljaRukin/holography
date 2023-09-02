close all;clear;clc;

%% setup
%all units are in mm
%matricies are structured as: (y/N/Dn,x/M/Dm,z), where y/N/Dn=vertial and x/M/Dm=horizontal direction
M = 2^11;%1920; %rendered window x resolution
N = 2^11;%1080; %rendered window y resolution
Dm = 0.008; %SLM x pixel pitch = hologram pixel pitch (except for fresnel propagation)
Dn = 0.008; %SLM y pixel pitch = hologram pixel pitch (except for fresnel propagation)
lambda = 0.000638;
k = 2*pi/lambda;
z = 100;

%% TTP-MMA Parameter
w = 0.032; %Pixelgröße
ax = -(10/3*pi)*Dm/w; ay = -(2/3*pi)*Dn/w; %Steigung der Rampe in m/m
%maximale Steigung ohne Aliasing ist: (pi)*Dm/w für ein SLM mit Pixelabstand w bzw. (pi) für ein SLM mit Pixelabstand Dm
kx = ax/Dm/k; ky = ay/Dn/k; %Steigung der Rampe in m/m
phi0 = pi/4; %Anfangsphase

%%%blazing offset
fprintf('blazing angle %.2f° (x) & %.2f° (y) \n',atan(kx)*180/pi,atan(ky)*180/pi);
bx = z*kx; by = z*ky;
fprintf('blazing offset %.2fmm (x) & %.2fmm (y) \n',bx,by);

%% coordinates
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1); %center around (0,0)
% [yy,xx] = ndgrid((-N/2:N/2-1)-by/Dn,(-M/2:M/2-1)-bx/Dm); %center around blazing maxima
% [yy,xx] = ndgrid((0:N-1)-2*ceil(w/Dn),(0:M-1)-2*ceil(w/Dm)); % position Pixel in left bottom corner
% offset
yy = Dn*yy; xx = Dm*xx;

%% file for saving errors
fid = fopen('./correlation.txt','w');

%% TTP-MMA Pixel Simulation 2
% shift phase center + grid
U_MMA2 = (1-1i).*exp(1i*phi0).*exp(-1i*pi/lambda*(2*(xx*kx+yy*ky)+z*(kx^2+ky^2))).*...
    (erfz((1-1i)*sqrt(pi/(2*lambda*z))*(+w/2-z*kx-xx))-erfz((1-1i)*sqrt(pi/(2*lambda*z))*(-w/2-z*kx-xx))).*...
    (erfz((1-1i)*sqrt(pi/(2*lambda*z))*(+w/2-z*ky-yy))-erfz((1-1i)*sqrt(pi/(2*lambda*z))*(-w/2-z*ky-yy)));
U_MMA2 = U_MMA2/max(abs(U_MMA2(:)));

%% display results
figure(3);title(['TTP-MMA2 Hologram Angle at z',num2str(z)]);imagesc(angle(U_MMA2));axis("equal");set(gca,'YDir','normal');colorbar();colormap('hsv'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
figure(4);title(['TTP-MMA2 Hologram Abs at z',num2str(z)]);imagesc(abs(U_MMA2));axis("equal");set(gca,'YDir','normal');colorbar();colormap('jet'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
fprintf(fid,'ERF: %.5f (default) \n',0);

fname = './phase_ttpmma_erf.png';
I = angle(U_MMA2); I = (I/pi+1)/2; I = uint8(I*255);
% imwrite(I(1024-1080/2+1:1024+1080/2,1024-1920/2+1:1024+1920/2),hsv(256),fname,'PNG');%% imwrite(I,hsv(256),fname,'PNG');
% print(3,fname,'-dpng','-r300');
% img = imread(fname); % imwrite(img(70:1240,133:1610,:),fname); %cropping
fname = './amp_ttpmma_erf.png';
I = abs(U_MMA2); I = I/max(I(:)); I = uint8(I*255);
% imwrite(I(1024-1080/2+1:1024+1080/2,1024-1920/2+1:1024+1920/2),jet(256),fname,'PNG');%% imwrite(I,jet(256),fname,'PNG');
% print(4,fname,'-dpng','-r300');
% img = imread(fname); % imwrite(img(70:1240,133:1610,:),fname); %cropping

%%%|a1*exp(i*phi1) - a2*exp(i*(phi2)-offset)| = |a1 - a2*exp(i*(phi2-offset-phi1))| => offset = avg(phi2-phi1)
% clear U_MMA2;

%% TTP-MMA Pixel Simulation 1
%%%exp(-1i*2*pi/(lambda*z)*(xx+z*ax+yy+z*ay))
% U_MMA1 = exp(1i*pi/(lambda*z)*(xx.^2 + yy.^2)).* ...
%     conv2( sinc(w*(xx+z*ax)/(lambda*z)).*sinc(w*(yy+z*ay)/(lambda*z))*exp(1i*phi0) , exp(-1i*pi/(lambda*z)*(xx.^2 + yy.^2)) ,'same');
zeropad = true;
U_MMA1 = exp(1i*pi/(lambda*z)*(xx.^2 + yy.^2)).* ...
    fftConvolution( sinc(w*(xx+z*kx)/(lambda*z)).*sinc(w*(yy+z*ky)/(lambda*z))*exp(1i*phi0) , exp(-1i*pi/(lambda*z)*(xx.^2 + yy.^2)) ,zeropad);
U_MMA1 = U_MMA1/max(abs(U_MMA1(:)));

%% display results
figure(5);title(['TTP-MMA1 Hologram Angle at z',num2str(z)]);imagesc(angle(U_MMA1));axis("equal");set(gca,'YDir','normal');colorbar();colormap('hsv'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
figure(6);title(['TTP-MMA1 Hologram Abs at z',num2str(z)]);imagesc(abs(U_MMA1));axis("equal");set(gca,'YDir','normal');colorbar();colormap('jet'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
fprintf(fid,'conv abs corr: %.5f \n',round(myCORR(abs(U_MMA1),abs(U_MMA2)),5));

fname = './phase_ttpmma_conv.png';
I = angle(U_MMA1); I = (I/pi+1)/2; I = uint8(I*255);
% imwrite(I(1024-1080/2+1:1024+1080/2,1024-1920/2+1:1024+1920/2),hsv(256),fname,'PNG');%% imwrite(I,hsv(256),fname,'PNG');
% print(5,fname,'-dpng','-r300');
% img = imread(fname); % imwrite(img(70:1240,133:1610,:),fname); %cropping
fname = './amp_ttpmma_conv.png';
I = abs(U_MMA1); I = I/max(I(:)); I = uint8(I*255);
% imwrite(I(1024-1080/2+1:1024+1080/2,1024-1920/2+1:1024+1920/2),jet(256),fname,'PNG');%% imwrite(I,jet(256),fname,'PNG');
% print(6,fname,'-dpng','-r300');
% img = imread(fname); % imwrite(img(70:1240,133:1610,:),fname); %cropping

offset=median(angle(U_MMA1(:))-angle(U_MMA2(:)))/2; fprintf(fid,'conv complex corr: %.5f \n',round(myCORR(U_MMA1*exp(-1i*offset),U_MMA2),5)); %phase corrected complex error
clear U_MMA1;

%% ASM propagation
U_D = exp(1i*(phi0+ax*xx/Dm+ay*yy/Dm)) .*(nosign(xx+1e-10)<w/2).*(nosign(yy+1e-10)<w/2); %Wellenfeld in SLM-Ebene

%%% display SLM-Plane Wavefield
figure(1);title('SLM-Plane Wavefield Angle z=0');imagesc(angle(U_D));axis("equal");set(gca,'YDir','normal');colorbar();colormap('hsv'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
figure(2);title('SLM-Plane Wavefield Abs z=0');imagesc(abs(U_D));axis("equal");set(gca,'YDir','normal');colorbar();colormap('jet'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));

zeropad = true;
U_O = angular_spectrum(U_D,z,Dm,Dn,lambda,zeropad);
clear U_D;
U_O = U_O/max(abs(U_O(:)));

%% display results
figure(7);title(['SLM Hologram Angle at z',num2str(z)]);imagesc(angle(U_O));axis("equal");set(gca,'YDir','normal');colorbar();colormap('hsv'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
figure(8);title(['SLM Hologram Abs at z',num2str(z)]);imagesc(abs(U_O));axis("equal");set(gca,'YDir','normal');colorbar();colormap('jet'); axis xy; axis equal;
ticks=(0:2*floor(M/2*Dm))/Dm; xticks(ticks+1);xticklabels((ticks)*Dm-floor(M/2*Dm));ticks=(0:2*floor(N/2*Dn))/Dn; yticks(ticks+1);yticklabels((ticks)*Dn-floor(N/2*Dn));
fprintf(fid,'ASM abs corr: %.5f \n',round(myCORR(abs(U_O),abs(U_MMA2)),5));

fname = './phase_ttpmma_ASM.png';
I = angle(U_O); I = (I/pi+1)/2; I = uint8(I*255);
% imwrite(I(1024-1080/2+1:1024+1080/2,1024-1920/2+1:1024+1920/2),hsv(256),fname,'PNG');%% imwrite(I,hsv(256),fname,'PNG');
% print(7,fname,'-dpng','-r300');
% img = imread(fname); % imwrite(img(70:1240,133:1610,:),fname); %cropping
fname = './amp_ttpmma_ASM.png';
I = abs(U_O); I = I/max(I(:)); I = uint8(I*255);
% imwrite(I(1024-1080/2+1:1024+1080/2,1024-1920/2+1:1024+1920/2),jet(256),fname,'PNG');%% imwrite(I,jet(256),fname,'PNG');
% print(8,fname,'-dpng','-r300');
% img = imread(fname); % imwrite(img(70:1240,133:1610,:),fname); %cropping

offset=median(angle(U_O(:))-angle(U_MMA2(:)))/2; fprintf(fid,'ASM complex corr: %.5f \n',round(myCORR(U_O*exp(-1i*offset),U_MMA2),5)); %phase corrected complex error
clear U_O;

%% close error saving
fclose(fid);
