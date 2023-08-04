function [error] = myCORR(I,I0)
%return pearson correlation coefficient
I = I-avg(I); I0 = I0-avg(I0);
error = sum(I(:).*conj(I0(:)))/sqrt(sum(sq2(I(:))).*sum(sq2(I0(:))));

%%% alternative (slower)
% error = sum( scaleNormalize(I(:)) .* conj(scaleNormalize(I0(:))) );
end