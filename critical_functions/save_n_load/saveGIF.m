function [] = saveGIF(I,filename,Tframe,compress)
%save image array as gif at specified filename.
%each image is displayed for Tframe-seconds.

if nargin < 4
	compress = 1;
end

nSlices = size(I,3);
if nSlices>1
    init = true;
    for nn=1:nSlices
        if init==true
            imwrite(uint8(round(scaleValues(I(:,:,nn),0,255)/compress)*compress),filename,'gif', 'Loopcount',inf);
            init = false;
        else 
            imwrite(uint8(round(scaleValues(I(:,:,nn),0,255)/compress)*compress),filename,'gif','WriteMode','append','DelayTime',Tframe); 
        end
    end
else
    fprintf('can not make gif from one frame only !');
end

end
