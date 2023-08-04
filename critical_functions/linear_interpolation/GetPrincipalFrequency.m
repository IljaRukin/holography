function [peak_x, peak_y, pOffset, maxVal] = GetPrincipalFrequency(InpFunc)
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

%peak position
peak_x = maxVal_x_pos - fDc_x;
peak_y = maxVal_y_pos - fDc_y;
end
