function WaveField = TTP2Phase(alphaX, alphaY, piston, NpixelX, NpixelY)

%number of pixels
[NmirrorY,NmirrorX,~] = size(alphaX);

% lokal coordinates of all samples on a pixel
% [xARY, yARY] = meshgrid( (-NpixelX/2+1/2:NpixelX/2-1/2) , (-NpixelY/2+1/2:NpixelY/2-1/2) );
[xARY, yARY] = meshgrid( (-NpixelX/2+1/2:NpixelX/2-1/2)/NpixelX , (-NpixelY/2+1/2:NpixelY/2-1/2)/NpixelY );

WaveField = zeros(NmirrorY*NpixelY,NmirrorX*NpixelX);
for m=1:NpixelX
    for n=1:NpixelY
        WaveField(n:NpixelX:end,m:NpixelY:end) = exp(1i*(piston + alphaX*xARY(n,m) + alphaY*yARY(n,m)));
    end
end

end