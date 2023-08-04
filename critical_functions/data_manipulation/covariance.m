function [x]=covariance(I,I0)
%returns covariance of inputs
x = sum( (I(:) - avg(I(:))).*(I0(:) - avg(I0(:))) )/numel(I);
end