%simple traingle rendering with custom spectral distribution and occlusion for multiple triangles from paper:
%Occlusion handling using angular spectrum convolution in fully analytical mesh based computer generated hologram
%made with help of loadawobj (implemented by William Harwin)
close all;clear;clc;
M = 2048;
N = 2048;
Mslm = 1080;
Nslm = 1920;
Dm = 0.008;
Dn = 0.008;
lambda = 0.000638;

%% load obj
obj = 'simple_objects2.obj';

%load obj
[v,f3,f4]=loadawobj(obj);

%split rectangles into triangles
if size(f4,2)~=0
    f3 = [f3,f4([1,2,3],:)];
    f3 = [f3,f4([1,3,4],:)];
end

%% two triangles
% zmin=-80; zmax=-100; %depth range in mm
% a=50;
% v = [[200,700,zmax].',[450,1450,zmax+a].',[1750,670,zmax-a].',[600,620,zmin-a].',[200,1200,zmin].',[1250,1400,zmin+a].'];
% v = v.*[Dm,Dn,1].';
% v(1,:) = v(1,:)-M/2*Dm; v(2,:) = v(2,:)-N/2*Dn;
% f3 = [[1,2,3].',[4,5,6].'];
% idx = [1,2];

%% interchange axis (rotate object)
order = {'+y','+x','+z'};
cmap = containers.Map;
cmap('-x')=-2; cmap('-y')=-1; cmap('-z')=-3; cmap('+x')=+2; cmap('+y')=+1; cmap('+z')=+3;
v_tmp = v;
for nn=1:3
    ax = cmap(char(order(nn)));
    v(nn,:) = sign(ax)*v_tmp(abs(ax),:);
end
clear v_tmp;

%% rotate verticies
%%%rotation around y-axis
theta1 = 0.1*pi/180;
R1 = [[cos(theta1),0,sin(theta1)].',[0,1,0].',[-sin(theta1),0,cos(theta1)].'].';
%%%rotation around x-axis
theta2 = 0.1*pi/180;
R2 = [[1,0,0].',[0,cos(theta2),-sin(theta2)].',[0,sin(theta2),cos(theta2)].'].';
% v(:,1:3) = R2*R1*v(:,1:3);
% v(:,4:6) = R2*R1*v(:,4:6);
v = R2*R1*v;

%% rotate verticies
% %%%rotation around y-axis
% theta1 = 2.0*pi/180;
% R1 = [[cos(theta1),0,sin(theta1)].',[0,1,0].',[-sin(theta1),0,cos(theta1)].'].';
% %%%rotation around x-axis
% theta2 = -1.0*pi/180;
% R2 = [[1,0,0].',[0,cos(theta2),-sin(theta2)].',[0,sin(theta2),cos(theta2)].'].';
% % v(:,1:3) = R2*R1*v(:,1:3);
% % v(:,4:6) = R2*R1*v(:,4:6);
% v = R2*R1*v;

%% adjust position/depth
%%% xmin=-4; xmax=4; %width in mm
%%% ymin=-2; ymax=3; %height in mm
zmin=-80; zmax=-100; %depth range in mm
% zmin=100; zmax=80; %depth range in mm
%%% v(1,:) = scaleValues(v(1,:),xmin,xmax);
%%% v(2,:) = scaleValues(v(2,:),ymin,ymax);
v(3,:) = scaleValues(v(3,:),zmin,zmax);

%% depth sort
depth = 1/3*( v(3,f3(1,:))+v(3,f3(2,:))+v(3,f3(3,:)) );
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
for nn=1:numel(idx)
    %triangle
    ind=idx(nn);
    rg1 = v(:,f3(1,ind));
    rg2 = v(:,f3(2,ind));
    rg3 = v(:,f3(3,ind));
    fprintf("N=%0.0f; ~z=%0.2f; \n",nn,-1*(rg1(3)+rg2(3)+rg3(3))/3);
    %% plot 2D view
% % %     plot(horzcat(v(1,1:3),v(1,1)),horzcat(v(2,1:3),v(2,1)));
    %%%Cdepth = abs( 1/3*( rg1(3)+rg2(3)+rg3(3) - zmax )/(zmax-zmin));
    x_points = v(1,f3([1,2,3,1],ind));
    y_points = v(2,f3([1,2,3,1],ind));
    z_points = v(3,f3([1,2,3,1],ind));
    col = z_points;
    surface([x_points;x_points],[y_points;y_points],[z_points;z_points],[col;col],'facecol','no','edgecol','interp','linew',2);
    %plot(v(1,f3([1,2,3,1],ind)),v(2,f3([1,2,3,1],ind)),'Color',[0,Cdepth,1-Cdepth]);
    colorbar();

    %% TRAFO
    %%% for some reason the depth has to be inverted
    rg1(3) = -rg1(3);
    rg2(3) = -rg2(3);
    rg3(3) = -rg3(3);
    %%% ru = unit triangle; rl = local plane triangle; rg = global triangle
    %%% ru = A^(-1)*(R*rg+c)
    %%% rg = R^(-1)*(A*ru-c)
    %%% rl = A*ru

    %rotate into plane
    [R,normal_vec] = getRotation3D(rg1,rg2,rg3);
    rl1 = R*rg1;
    rl2 = R*rg2;
    rl3 = R*rg3;

%     fprintf('%.3f / %.3f / %.3f \n',normal_vec);
%     %%%if plane too much tilted -> invisible to observer -> skip it
%     if nosign(normal_vec.'*[0,0,1].') < 0.1%cos(asin(lambda/(2*Dm)))
%         continue
%     end

    %shift rg1 to origin
    c = -rl1;
    rl3 = rl3 + c;
    rl2 = rl2 + c;
    rl1 = rl1 + c; % = [0,0,0].';

    %transform to unit triangle
    A=[[rl2(1) , (rl3(1)-rl2(1))].', [rl2(2) , (rl3(2)-rl2(2))].'].';
%     iA = inv(A);
%     ru1 = iA*rl1(1:2);
%     ru2 = iA*rl2(1:2);
%     ru3 = iA*rl3(1:2);

    %transform back
%     rgb1 = inv(R)*(vertcat(A*ru1,0)-c);
%     rgb2 = inv(R)*(vertcat(A*ru2,0)-c);
%     rgb3 = inv(R)*(vertcat(A*ru3,0)-c);
%     fprintf('trafo error: %.3f \n',sum(nosign(rgb1-rg1)));
%     fprintf('trafo error: %.3f \n',sum(nosign(rgb2-rg2)));
%     fprintf('trafo error: %.3f \n',sum(nosign(rgb3-rg3)));

    %origin of local coord. in global coord.
    r0 = rg1;
    %frequencies in local coord.
    %iR = inv(R);
    flx = R(1,1)*fgx+R(1,2)*fgy+R(1,3)*fgz;
    fly = R(2,1)*fgx+R(2,2)*fgy+R(2,3)*fgz;
    flz = R(3,1)*fgx+R(3,2)*fgy+R(3,3)*fgz;

    %% combine transformations
    T = A.'*R(1:2,:);

    %% intensity corrections
    cI = abs(det(A))/(Dm*Dn)/(M*N);

%     %% option 1 - single plane carrier wave
%     %%% single plane carrier wave & no occlusion
%     B = cI*UnitTriangleFT( T(1,1)*(fgx-vx)+T(1,2)*(fgy-vy)+T(1,3)*(fgz-vz), T(2,1)*(fgx-vx)+T(2,2)*(fgy-vy)+T(2,3)*(fgz-vz) );
%     B = B .*exp(2*pi*1i*(vx*r0(1)+vy*r0(2)+vz*r0(3))); %carrier wave in direction [vx,vy,vz]
% %     B = B*sqrt(nosign(normal_vec.'*[0,0,1].')); % flat shading

    %% option 2 - multiple plane carrier waves
 	B = cI*UnitTriangleFT( T(1,1)*(fgx-vx)+T(1,2)*(fgy-vy)+T(1,3)*(fgz-vz), T(2,1)*(fgx-vx)+T(2,2)*(fgy-vy)+T(2,3)*(fgz-vz) );
	%%% single plane carrier wave (approximation)
%     D = zeros(N,M); D(N/2+1,M/2+1)=1;
    %%% many plane carrier waves with same phase, problem with vignetting
%     D = 1;
	%%% multiple plane carrier waves
    D = ( (xx.^2+yy.^2) < 500^2 ).*exp(2*pi*1i*rand(N,M));
    %%% random phase
%     D = exp(2*pi*1i*rand(N,M));

    %%% uni-directional flat shading
%     D = D*sqrt(nosign(normal_vec.'*[0,0,1].')); %=cos(alpha)

    %%% multi-directional flat shading
    D = D.*sqrt(nosign(normal_vec(1)*(fgx)*lambda+normal_vec(2)*(fgy)*lambda+normal_vec(3)*(fgz)*lambda)); %=cos(alpha)

    %%% enable occlusion (without occlusion: problems with self-interference)
    D = D-FTofE; %occlusion

    %%% remaining steps of option 2: correct phase & combine
    D = D .*exp(2*pi*1i*((fgx)*r0(1)+(fgy)*r0(2)+(fgz)*r0(3)));
    %%%Ffull = conv2(D,B,'same'); %exact convolution
    zeropad = true;
    B = fftConvolution(B,D,zeropad);

    %% add remaining terms
    B = B .*exp(2*pi*1i*(flx*c(1)+fly*c(2)+flz*c(3))).*flz./fgz;%/(det((A)));
    FTofE = FTofE + B;
end
E = fftshift(ifft2(fftshift( FTofE )));

path = '../results/';

%% plot 2D view
hold off
axis('equal'); axis xy; title('wireframe');
xticks(-8:2:8); yticks(-4:2:4); xlim([-Mslm/2*Dm,Mslm/2*Dm]); ylim([-Nslm/2*Dn,Nslm/2*Dn]);
xticks(-8:2:8); yticks(-8:2:8); xlim([-M/2*Dm,M/2*Dm]); ylim([-N/2*Dn,N/2*Dn]);
print(gcf,[path,'Triangles_',num2str(zmin),'_',num2str(zmax),'_Wireframe.png'],'-dpng','-r300');

%% display/save results
figure(2);imagesc(abs( E ));colorbar();colormap(gray); axis('equal');axis xy;
figure(3);imagesc(abs( angular_spectrum(E,zmin,Dm,Dn,lambda,true) ));colorbar();colormap(gray); axis('equal');axis xy; title(['propagated z= ',int2str(zmin),' mm']);
print(gcf,[path,'Triangles_',num2str(zmin),'_',num2str(zmax),'_propagated_',num2str(zmin),'.png'],'-dpng','-r300');
figure(4);imagesc(abs( angular_spectrum(E,zmax,Dm,Dn,lambda,true) ));colorbar();colormap(gray); axis('equal');axis xy; title(['propagated z= ',int2str(zmax),' mm']);
print(gcf,[path,'Triangles_',num2str(zmin),'_',num2str(zmax),'_propagated_',num2str(zmax),'.png'],'-dpng','-r300');

parameters = ['z',num2str(zmin),'_z',num2str(zmax),'_lambda',num2str(lambda*1e+6),'_Dm',num2str(Dm*1e+3),'_Dn',num2str(Dn*1e+3)];
saveFPImage(E,[path,'Triangles_',parameters,'.fp.img']);
