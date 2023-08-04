function [tformEstimate] = refine_undistort_trafo(distorted,original,tformEstimate)

%% approx register image - intensity-based
% [optimizer,metric] = imregconfig('monomodal');
% optimizer.MaximumIterations = 50;
% tformEstimate = imregtform(distorted,original,"similarity",optimizer,metric,'InitialTransformation',tformEstimate);

%% approx register image - intensity-based
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 300;
tformEstimate = imregtform(distorted,original,"affine",optimizer,metric,'InitialTransformation',tformEstimate);

end