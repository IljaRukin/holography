function [x]=avg(x)
%returns average value
x=sum(x(:))/numel(x);
end