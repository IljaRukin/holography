function [U] = slice_vol_obj(obj,M,N,nSlices,wx,wy,order)
%{
function loads obj-model with name "obj" made of triangles and rectangles.
the model is positioned inside a volume with size (wy,wx,nSlices) and
all grid-points inside the object are set to 1.
the result is zero-filled to (N,M,nSlices) and returned.

###made with help of:
*loadawobj (implemented by William Harwin)
*inpolyhedron (implemented by Sven Holcombe)
%}

%use coordinates for calculation, otherwise extreme errors present!
use_coordinates = true;

%load obj
[v,f3,f4]=loadawobj(obj);

%split rectangles into triangles
if size(f4,2)~=0
    f3 = [f3,f4([1,2,3],:)];
    f3 = [f3,f4([1,3,4],:)];
end

%interchange axis (rotate object)
cmap = containers.Map;
cmap('-x')=-2;cmap('-y')=-1;cmap('-z')=-3;cmap('+x')=+2;cmap('+y')=+1;cmap('+z')=+3;
v_tmp = v;
for nn=1:3
    ax = cmap(char(order(nn)));
    v(nn,:) = sign(ax)*v_tmp(abs(ax),:);
end

%generate grid
low = min(v,[],2); high = max(v,[],2);
dx = (high(1)-low(1))/(wx-1); dy = (high(2)-low(2))/(wy-1); dz = (high(3)-low(3))/(nSlices-1);
if use_coordinates
    %coordinate position grid (floating-point positions)
    x = low(1):dx:high(1);
    y = low(2):dy:high(2);
    z = low(3):dz:high(3);
else
    %discrete grid (whole numbers)
    x = 1:wx; y = 1:wy; z = 1:nSlices;
    
    %round verticies to nearest point on grid
    v(1,:) = round((v(1,:)-low(1))./dx)+1;
    v(2,:) = round((v(2,:)-low(2))./dy)+1;
    v(3,:) = round((v(3,:)-low(3))./dz)+1;
end

%slice (point inside object =1, else =0)
in = inpolyhedron(f3.',v.',x,y,z,'TOL',dx/2,'GRIDSIZE',min(wx,wy)); %,'FLIPNORMALS','True'

%fill array of slices
U = zeros(N,M,nSlices);
U(ceil(N/2)-ceil(wy/2):ceil(N/2)+floor(wy/2)-1, ceil(M/2)-ceil(wx/2):ceil(M/2)+floor(wx/2)-1, :) = in;

end