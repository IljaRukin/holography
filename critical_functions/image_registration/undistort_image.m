function [undistorted] = undistort_image(distorted,original)

%% approx register image - (fourier-space) phase correlation
tformEstimate = imregcorr(distorted,original);

%% approx register image - intensity-based
% [optimizer,metric] = imregconfig('monomodal');
% optimizer.MaximumIterations = 50;
% tformEstimate = imregtform(distorted,original,"similarity",optimizer,metric,'InitialTransformation',tformEstimate);

%% register image - intensity-based
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 300;
undistorted = imregister(distorted,original,'affine',optimizer,metric,'InitialTransformation',tformEstimate);

%% scale mean value
undistorted = undistorted *(avg(original)/avg(undistorted));

end