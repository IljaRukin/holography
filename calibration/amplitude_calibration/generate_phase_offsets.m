lambda = 0.0006328;
Mslm = 1920;Nslm = 1080;
[xx,yy]=meshgrid(-Mslm/2+1:Mslm/2,-Nslm/2+1:Nslm/2);
mask = (xx.^2+yy.^2<400^2);

phiRGB = zeros(Nslm,Mslm,3);

N=20;
for a=0:N
    offset = 2*pi*a/N;
    phiRGB(:,:,1) = mask*offset;
    phiRGB = mod(phiRGB/(2*pi),1) *lambda/0.000633;
    imwrite(phiRGB,[sprintf('%03.01f',lambda*1e+6),'_',sprintf('%01.03f',a/N),'.png']);
end