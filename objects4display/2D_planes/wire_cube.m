function [U] = wire_cube(M,N,nSlices,dCubeX,dCubeY,edgeWidth,fb_offset)
%generate wire rectangle with size (dCubeY,dCubeX,nSlices) and an offset of "fb_offset"
%between front and rear planes and an edgewidth of "edgeWidth" inside a volume of size (N,M,nSlices).
%the edges between the front and rear plane are represented by lines by projecting to the nearest plane.

U = zeros(N,M,nSlices);

y0Front = round(N/2 - dCubeY/2 + fb_offset/2);
x0Front = round(M/2 - dCubeX/2 - fb_offset/2);
x1Front = x0Front + dCubeX;
y1Front = y0Front + dCubeY;
x0Back = x0Front + fb_offset;
y0Back = y0Front - fb_offset;
x1Back = x0Back + dCubeX;
y1Back = y0Back + dCubeY;

%Vorderseite
U(y0Front:y1Front,[x0Front:x0Front+edgeWidth-1,x1Front:x1Front+edgeWidth-1],1) = 1;
U([y0Front:y0Front+edgeWidth-1,y1Front:y1Front+edgeWidth-1],x0Front:x1Front,1) = 1;

%Hinterseite
U(y0Back:y1Back,[x0Back:x0Back+edgeWidth-1,x1Back:x1Back+edgeWidth-1],end) = 1;
U([y0Back:y0Back+edgeWidth-1,y1Back:y1Back+edgeWidth-1],x0Back:x1Back,end) = 1;

% Kanten in z-Richtung
iSlice = 2;
counter = 0;
for pos=1:fb_offset-1
    
    if (counter*(nSlices-2)/fb_offset) > 1
        iSlice = iSlice +1;
        counter = 0;
    end
    
    U((y0Front-pos):(y0Front-pos+edgeWidth-1),(x0Front+pos):(x0Front+pos+edgeWidth-1),iSlice) = 1;
    U((y1Front-pos):(y1Front-pos+edgeWidth-1),(x0Front+pos):(x0Front+pos+edgeWidth-1),iSlice) = 1;
    U((y0Front-pos):(y0Front-pos+edgeWidth-1),(x1Front+pos):(x1Front+pos+edgeWidth-1),iSlice) = 1;
    U((y1Front-pos):(y1Front-pos+edgeWidth-1),(x1Front+pos):(x1Front+pos+edgeWidth-1),iSlice) = 1;
    
    counter = counter+1;
end

U(U>1)=1;

end

