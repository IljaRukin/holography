function [peak_x, peak_y, pOffset, maxVal] = GetPrincipalFrequency_subpixel(InpFunc)
% Determine size of distribution
[ROI_size_y,ROI_size_x] = size(InpFunc);

%center of fourier domain
fDc_x = floor(ROI_size_x/2)+1;
fDc_y = floor(ROI_size_y/2)+1;

% Fourier transform complex function to find peak
fInpFunc = fftshift(fft2(fftshift(InpFunc)));
fInpFuncAng = angle(fInpFunc);
fInpFunc = abs(fInpFunc);

% Find position of maximum value on pixel scale
[maxVal_y, maxVal_y_pos] = max(fInpFunc);
[maxVal, maxVal_x_pos] = max(maxVal_y);
maxVal_y_pos = maxVal_y_pos(maxVal_x_pos);

% Save phase for return
pOffset = fInpFuncAng(maxVal_y_pos, maxVal_x_pos);

% Subpixel weighting
% Find x coordinate of peak via Sync approximation
fA = fInpFunc(maxVal_y_pos, maxVal_x_pos);
[fB, fA_sign] = max([fInpFunc(maxVal_y_pos, maxVal_x_pos-1) fInpFunc(maxVal_y_pos, maxVal_x_pos+1)]);
fA_sign = (fA_sign-1.5)*2;
c0 = fB-fA+fA*pi^2/6;
c1 = fA*pi^2/3;
dA = fA_sign*c0/c1;
peak_x = maxVal_x_pos - fDc_x + dA;

% Find y coordinate of peak via Sync approximation
fA = fInpFunc(maxVal_y_pos, maxVal_x_pos);
[fB, fA_sign] = max([fInpFunc(maxVal_y_pos-1, maxVal_x_pos) fInpFunc(maxVal_y_pos+1, maxVal_x_pos)]);
fA_sign = (fA_sign-1.5)*2;
c0 = fB-fA+fA*pi^2/6;
c1 = fA*pi^2/3;
dA = fA_sign*c0/c1;
peak_y = maxVal_y_pos - fDc_y + dA;
end
