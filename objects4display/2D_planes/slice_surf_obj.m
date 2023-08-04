function [U] = slice_surf_obj(obj,M,N,nSlices,wx,wy,order)
%{
function loads obj-model with name "obj" made of triangles and rectangles.
the model is positioned inside a volume with size (wy,wx,nSlices) and
nearest grid-points to object are set to 1.
the result is zero-filled to (N,M,nSlices) and returned.

###made with help of:
*loadawobj (implemented by William Harwin)
*tracing the triangles by a 3D variant of Bresenham-Algorithm (implemented by Ilja Rukin)
%}

%load obj
[v,f3,f4]=loadawobj(obj);

%split rectangles into triangles
if size(f4,2)~=0
    f3 = [f3,f4([1,2,3],:)];
    f3 = [f3,f4([1,3,4],:)];
end

%interchange axis (rotate object)
cmap = containers.Map;
cmap('-x')=-1;cmap('-y')=-2;cmap('-z')=-3;cmap('+x')=+1;cmap('+y')=+2;cmap('+z')=+3;
v_tmp = v;
for nn=1:3
    ax = cmap(char(order(nn)));
    v(nn,:) = sign(ax)*v_tmp(abs(ax),:);
end

%generate grid
n = [wy,wx,nSlices];
low = min(v,[],2); high = max(v,[],2);
dx = (high(1)-low(1))/(n(1)-3); dy = (high(2)-low(2))/(n(2)-3); dz = (high(3)-low(3))/(n(3)-3);

%tmp=dx; dx=dz; dz=dy; dy=tmp;
%tmp=low(1); low(1)=low(3); low(3)=low(2); low(2)=tmp;

%slice (point on triangle surface =1, else =0)
in = false(n);
for ii=1:size(f3,2)
    %get vertex points
    p1 = v(:,f3(1,ii));
    p2 = v(:,f3(2,ii));
    p3 = v(:,f3(3,ii));
    %round to nearest point on grid
    p1(1) = round((p1(1)-low(1))/dx)+1; p1(2) = round((p1(2)-low(2))/dy)+1; p1(3) = round((p1(3)-low(3))/dz)+1;
    p2(1) = round((p2(1)-low(1))/dx)+1; p2(2) = round((p2(2)-low(2))/dy)+1; p2(3) = round((p2(3)-low(3))/dz)+1;
    p3(1) = round((p3(1)-low(1))/dx)+1; p3(2) = round((p3(2)-low(2))/dy)+1; p3(3) = round((p3(3)-low(3))/dz)+1;
    %select longest axis
    maxi = zeros(3,1); indx = zeros(3,1);
    [maxi(1),indx(1)] = max(abs(p1-p2)); [maxi(2),indx(2)] = max(abs(p2-p3)); [maxi(3),indx(3)] = max(abs(p3-p1));
    [~,axind] = max(maxi);
    axis = indx(axind);
    %sort along max-axis into pmax,pmid,pmin
    if p1(axis)>p2(axis)
        if p1(axis)>p3(axis)
            if p2(axis)>p3(axis)
                pmax=p1;pmid=p2;pmin=p3;
            else
                pmax=p1;pmid=p3;pmin=p2;
            end
        else
            pmax=p3;pmid=p1;pmin=p2;
        end
    else
        if p2(axis)>p3(axis)
            if p1(axis)>p3(axis)
                pmax=p2;pmid=p1;pmin=p3;
            else
                pmax=p2;pmid=p3;pmin=p1;
            end
        else
            pmax=p3;pmid=p2;pmin=p1;
        end
    end
    %trace lower and upper bounds along x-axis
    bound1 = trace_line_3d_axis(pmin,pmax,axis,pmax(axis)-pmin(axis));
    bound2 = trace_line_3d_axis(pmin,pmid,axis,pmid(axis)-pmin(axis));
    bound3 = trace_line_3d_axis(pmid,pmax,axis,pmax(axis)-pmid(axis));
    bound0 = [bound2(:,1:end-1),bound3];
    %fill points between bounds
    for jj=1:(pmax(axis)-pmin(axis)+1)
        in = trace_line_3d(bound0(:,jj),bound1(:,jj),in);
    end
end

%fill array of slices
U = zeros(N,M,nSlices);
U(ceil(N/2)-ceil(wy/2):ceil(N/2)+floor(wy/2)-1, ceil(M/2)-ceil(wx/2):ceil(M/2)+floor(wx/2)-1, :) = in;

end