%simple traingle rendering with custom spectral distribution and occlusion for multiple triangles from paper:
%Occlusion handling using angular spectrum convolution in fully analytical mesh based computer generated hologram
%made with help of loadawobj (implemented by William Harwin)
close all;clear;clc;
M = 2048;
N = 2048;
Mslm = 1920;
Nslm = 1080;
Dm = 0.008;
Dn = 0.008;
lambda = 0.000638;

%% verticies - cube
x1=-3; x2=3; %width in mm
y1=-2; y2=2; %height in mm
z1=-2.5; z2=2.5; %depth range in mm
% zmin=-80; zmax=-100; %depth range in mm
zmin=100; zmax=80; %depth range in mm
v = zeros(3,8);
v(1,:) = [x1,x1,x2,x2,x1,x1,x2,x2];
v(2,:) = [y1,y2,y1,y2,y1,y2,y1,y2];
v(3,:) = [z1,z1,z1,z1,z2,z2,z2,z2];

%% rotate verticies
%rotation around y-axis
theta1 = 20*pi/180;
R1 = [[cos(theta1),0,sin(theta1)].',[0,1,0].',[-sin(theta1),0,cos(theta1)].'].';
%rotation around x-axis
theta2 = 10*pi/180;
R2 = [[1,0,0].',[0,cos(theta2),-sin(theta2)].',[0,sin(theta2),cos(theta2)].'].';
v = R2*R1*v;

%offset in space
v(3,:) = scaleValues(v(3,:),zmin,zmax);

%% faces - cube
f2 = zeros(2,12);
f2(1,:) = [1,1,2,3, 1+4,1+4,2+4,3+4, 1,  2,  3,  4,  ];
f2(2,:) = [2,3,4,4, 2+4,3+4,4+4,4+4, 1+4,2+4,3+4,4+4,];

%% depth sort
depth = 1/2*( v(3,f2(1,:)) + v(3,f2(2,:)) );
[~,idx] = sort(depth,'ascend');

%% setup scene
%coordinates
[y,x] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
x = x*Dm;
y = y*Dn;

%frequencies
[yy,xx] = ndgrid(-N/2:N/2-1,-M/2:M/2-1);
fgx = xx/(M*Dm);
fgy = yy/(N*Dn);
fgz = real( sqrt(1/lambda^2-fgx.^2-fgy.^2) );

%plane carrier wave
theta_x = 0;
theta_y = 0;
vx = 1/lambda*sin(theta_x);
vy = 1/lambda*sin(theta_y);
vz = real(sqrt(1/lambda^2-vx^2-vy^2));

%% plot 2D view
hold on
figure(1);

%% calculate wavefield
FTofE = zeros(N,M);
for ind=1:numel(f2(1,:))
    %line
    rg1 = v(:,f2(1,ind));
    rg2 = v(:,f2(2,ind));
    fprintf("N=%0.0f; z=%0.2f; \n",ind,-1*(rg1(3)+rg2(3))/2);
    %% plot 2D view
% % %     plot(horzcat(v(1,1:3),v(1,1)),horzcat(v(2,1:3),v(2,1)));
    %%%Cdepth = abs( 1/3*( rg1(3)+rg2(3)+rg3(3) - zmax )/(zmax-zmin));
    x_points = v(1,f2([1,2],ind));
    y_points = v(2,f2([1,2],ind));
    z_points = v(3,f2([1,2],ind));
    col = z_points;
    surface([x_points;x_points],[y_points;y_points],[z_points;z_points],[col;col],'facecol','no','edgecol','interp','linew',2);
    %plot(v(1,f3([1,2,3,1],ind)),v(2,f3([1,2,3,1],ind)),'Color',[0,Cdepth,1-Cdepth]);
    colorbar();

    %% TRAFO
    %%% for some reason the depth has to be inverted
    rg1(3) = -rg1(3);
    rg2(3) = -rg2(3);
    %%% ru = unit triangle; rl = local plane triangle; rg = global triangle
    %%% ru = A^(-1)*(R*rg+c)
    %%% rg = R^(-1)*(A*ru-c)
    %%% rl = A*ru

    %rotate into plane
    [R,normal_vec] = getRotation3D(rg1,rg2,rg1+rg2);
    rl1 = R*rg1;
    rl2 = R*rg2;

    %shift rg1 to origin
    c = -rl1;
    rl2 = rl2 + c;
    rl1 = rl1 + c; % = [0,0,0].';

%     fprintf('%.3f / %.3f / %.3f \n',normal_vec);
%     %%%if plane too much tilted -> invisible to observer -> skip it
%     if nosign(normal_vec.'*[0,0,1].') < 0.1%cos(asin(lambda/(2*Dm)))
%         continue
%     end

    %transform to unit line (-1,-1)---(1,1)
    A=[[rl2(1) , 0].', [0 , rl2(2)].'].';
%     iA = inv(A);
%     iA=[[1/rl2(1) , 0].', [0 , 1/rl2(2)].'].';
%     ru1 = iA*rl1(1:2);
%     ru2 = iA*rl2(1:2);

    %transform back
%     rgb1 = inv(R)*(vertcat(A*ru1,0)-c);
%     rgb2 = inv(R)*(vertcat(A*ru2,0)-c);
%     fprintf('trafo error: %.3f \n',sum(nosign(rgb1-rg1)));
%     fprintf('trafo error: %.3f \n',sum(nosign(rgb2-rg2)));

    %origin of local coord. in global coord.
    r0 = rg1;
    %frequencies in local coord.
    flx = R(1,1)*fgx+R(1,2)*fgy+R(1,3)*fgz;
    fly = R(2,1)*fgx+R(2,2)*fgy+R(2,3)*fgz;
    flz = R(3,1)*fgx+R(3,2)*fgy+R(3,3)*fgz;

    %% combine transformations
    T = A.'*R(1:2,:);

    %% intensity corrections
    cI = sqrt(sum((rg2(1:2)-rg1(1:2)).^2))/(Dm*Dn)/(M*N); %intensity correction by length of line (rotation-independent)
    linewidth = 2*Dn/(N*Dn); %does not really work

    %% option 1 - single plane carrier wave
%     %%% single plane carrier wave & no occlusion
%     B = cI*UnitLineFT( T(1,1)*(fgx-vx)+T(1,2)*(fgy-vy)+T(1,3)*(fgz-vz), T(2,1)*(fgx-vx)+T(2,2)*(fgy-vy)+T(2,3)*(fgz-vz), linewidth);
%     B = B .*exp(2*pi*1i*(vx*r0(1)+vy*r0(2)+vz*r0(3))); %carrier wave in direction [vx,vy,vz]

    %% option 2 - multiple plane carrier waves
    B = cI*UnitLineFT( T(1,1)*(fgx-vx)+T(1,2)*(fgy-vy)+T(1,3)*(fgz-vz), T(2,1)*(fgx-vx)+T(2,2)*(fgy-vy)+T(2,3)*(fgz-vz), linewidth);
	%%% single plane carrier wave (approximation)
%     D = zeros(N,M); D(N/2+1,M/2+1)=1;
    %%% many plane carrier waves with same phase, problem with vignetting
%     D = 1;
	%%% multiple plane carrier waves
%     D = ( (xx.^2+yy.^2) < 500^2 ).*exp(2*pi*1i*rand(N,M));
    %%% random phase
    D = exp(2*pi*1i*rand(N,M));

    %%% uni-directional flat shading
%     D = D*sqrt(nosign(normal_vec.'*[0,0,1].')); %=cos(alpha)

    %%% multi-directional flat shading
%     D = D.*sqrt(nosign(normal_vec(1)*(fgx)*lambda+normal_vec(2)*(fgy)*lambda+normal_vec(3)*(fgz)*lambda)); %=cos(alpha)

    %%% enable occlusion
%     D = D-FTofE; %occlusion

    %%% remaining steps of option 2: correct phase & combine
    D = D .*exp(2*pi*1i*((fgx)*r0(1)+(fgy)*r0(2)+(fgz)*r0(3)));
    %%%Ffull = conv2(Ffull,D,'same'); %exact convolution
    zeropad = true;
    B = fftConvolution(B,D,zeropad);

    %% add remaining terms
    B = B .*exp(2*pi*1i*(flx*c(1)+fly*c(2)+flz*c(3))).*flz./fgz;
    FTofE = FTofE + B;
end
E = fftshift(ifft2(fftshift( FTofE )));

path = '../results/';

%% plot 2D view
hold off
axis('equal'); axis xy;
% xticks(-8:2:8); yticks(-4:2:4); xlim([-Mslm/2*Dm,Mslm/2*Dm]); ylim([-Nslm/2*Dn,Nslm/2*Dn]);
xticks(-8:2:8); yticks(-8:2:8); xlim([-M/2*Dm,M/2*Dm]); ylim([-N/2*Dn,N/2*Dn]);
print(gcf,[path,'Lines_',num2str(zmin),'_',num2str(zmax),'_Wireframe.png'],'-dpng','-r300');

%% display/save results
figure(2);imagesc(abs( E ));colorbar();colormap(gray);set(gca,'YDir','normal');axis("equal");
figure(3);imagesc(abs( angular_spectrum(E,zmin,Dm,Dn,lambda,true) ));colorbar();colormap(gray); axis('equal');axis xy; title(['propagated z= ',int2str(zmin),' mm']);
print(gcf,[path,'Lines_',num2str(zmin),'_',num2str(zmax),'_propagated_',num2str(zmin),'.png'],'-dpng','-r300');
figure(4);imagesc(abs( angular_spectrum(E,zmax,Dm,Dn,lambda,true) ));colorbar();colormap(gray); axis('equal');axis xy; title(['propagated z= ',int2str(zmax),' mm']);
print(gcf,[path,'Lines_',num2str(zmin),'_',num2str(zmax),'_propagated_',num2str(zmax),'.png'],'-dpng','-r300');

parameters = ['z',num2str(zmin),'_z',num2str(zmax),'_lambda',num2str(lambda*1e+6),'_Dm',num2str(Dm*1e+3),'_Dn',num2str(Dn*1e+3)];
saveFPImage(E,[path,'Lines_',parameters,'.fp.img']);
