function x = scaleNormalize(x)
%normalize array: mean = 0 & standard_deviation = sqrt(variance) = Pixelcount
x = x-avg(x(:));
x = x/sqrt(variance(x(:))*numel(x));
end