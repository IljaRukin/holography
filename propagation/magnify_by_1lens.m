function [U,zSlices] = magnify_by_1lens(U,zSlices,m,f1)
%magnify object planes provided in U with lens of focal length f1 by factor m.
%the object planes U are returned prescaled for display and the distances zSlices
%are adjusted to the correct image distances in front of lens.
%a negeative magnification factor m produces a virtual image.

N = size(U,1);
M = size(U,2);
nSlices = size(U,3);

fprintf('the magnified object will appear at distance z between %.3f mm and %.3f mm from SLM \n',(zSlices(1)),(zSlices(end)));

b0 = (m+1)*f1; %image distance for magnification by m without prescaling m/mi
if m<0 %virtual image
    zlens = zSlices(end)-b0; %position of lens: furthest plane magnified by lens by m, nearer planes need to be scaled down
    %this way the content on the display never exceeds the dimensions of the display !
else %real image
    zlens = zSlices(1)-b0; %position of lens: nearest plane magnified by lens by m, further planes need to be scaled down
    %this way the content on the display never exceeds the dimensions of the display !
end
fprintf('the lens position is %.3f mm from SLM away \n',(zlens));

imSlices = zSlices;
for iSlice = 1:nSlices
    z = zSlices(iSlice);

    bi = z-zlens;
    gi = 1/(1/f1-1/bi);
    mi = bi/gi;
    fprintf('magnification %f \n',mi);
    %fprintf('%f \n',m/mi);

    %correct image magnification
    %U(:,:,iSlice) = imresize(U(:,:,iSlice),'Scale',m/mi,'OutputSize',[N,M]);
    iU = imresize(U(:,:,iSlice),'Scale',abs(m/mi));
    U(:,:,iSlice) = crop(iU,N,M);

    %adjust position of hologram plane
    zSlices(iSlice) = z-bi-gi;
end

fprintf('reconstruction plane is located between %.3f mm and %.3f mm from SLM in front of lens \n',(zSlices(1)),(zSlices(end)));

end