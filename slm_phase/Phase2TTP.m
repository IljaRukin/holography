function [alphaX, alphaY, piston, ampMax] = Phase2TTP(WaveField, NpixelX, NpixelY)

%set size to multiples of PixPerMirror
[N,M,~] = size(WaveField);
Mmirror = floor(M/NpixelX);
Nmirror = floor(N/NpixelY);

%arrays for parameters
alphaX = zeros(Nmirror,Mmirror);
alphaY = zeros(Nmirror,Mmirror);
piston = zeros(Nmirror,Mmirror);
ampMax = zeros(Nmirror,Mmirror);

% lokal coordinates of all samples on a pixel
% [xARY, yARY] = meshgrid( (-NpixelX/2+1/2:NpixelX/2-1/2) , (-NpixelY/2+1/2:NpixelY/2-1/2) );
[xARY, yARY] = meshgrid( (-NpixelX/2+1/2:NpixelX/2-1/2)/NpixelX , (-NpixelY/2+1/2:NpixelY/2-1/2)/NpixelY );

%%%%% build the Moore-Penrose pseudoinverse for the full column rank
%%%%% (A is real valued so transpose is sufficient, no need for complex conjugate)
% % A = [xARY(:) yARY(:) (transpose(1:(NpixelX*NpixelY))*0+1)];
% % A_MPinv = inv(transpose(A) * A) * transpose(A);

for x=1:Mmirror
    x_pos = (x-1)*NpixelX;
    for y=1:Nmirror
        y_pos = (y-1)*NpixelY;
        % patch across current pixel
        pPatch = WaveField((y_pos+1):(y_pos+NpixelY), (x_pos+1):(x_pos+NpixelX));

        % local frequency peak frequency (direction) and phase offset across the patch
        [kx, ky, pOffset, maxVal] = GetPrincipalFrequency(pPatch);
        kx = 2*pi*kx; ky = 2*pi*ky;
        % first linear fit
        pPatchEst = xARY * kx + yARY * ky + pOffset;
        % residual error
        pPatchRes = angle( pPatch.*conj(exp(1i*pPatchEst)) );
        %try to optimally correct piston-term (no improvement)
        %(simple average is wrong, since any phase-shift is accompanied by a modulo 2pi operation which shifts the average again)
% % %         addOffset=calc_offset(pPatchRes); pPatchRes=angle(exp(1i*(pPatchRes+addOffset))); pOffset=pOffset+addOffset;

        % linear fit error
        p = zeros(3,1);
        if sum(nosign(pPatchRes(:)))>1e-8 %fit if pPatchRes nonzero
% %           p = A_MPinv * pPatchRes(:); % linear fit with pseudoinverse
%         [p(1),p(3)] = linfit1D(xARY(:),pPatchRes(:),ones(size(pPatch(:)))); % 1D fit unweighted part1 (identical to pseudoinverse fit)
%         [p(2),p(3)] = linfit1D(yARY(:),pPatchRes(:),ones(size(pPatch(:)))); % 1D fit unweighted part2 (identical to pseudoinverse fit)
%         [p(1),p(3)] = linfit1D(xARY(:),pPatchRes(:),abs(pPatch(:))); % 1D fit weighted part1
%         [p(2),p(3)] = linfit1D(yARY(:),pPatchRes(:),abs(pPatch(:))); % 1D fit weighted part2
%         [p(1),p(2),p(3)] = linfit2D(xARY(:),yARY(:),pPatchRes(:),ones(size(pPatch(:)))); % 2D fit unweighted
        [p(1),p(2),p(3)] = linfit2D(xARY(:),yARY(:),pPatchRes(:),abs(pPatch(:))); % 2D fit weighted
        end

        % parameters
        alphaX(y,x) = kx + p(1);
        alphaY(y,x) = ky + p(2);
        piston(y,x) = pOffset + p(3); % + pi*(maxVal<0) %%%does not occur, since maxVal=max(abs(...))
        ampMax(y,x) = abs(maxVal);
    end
end
