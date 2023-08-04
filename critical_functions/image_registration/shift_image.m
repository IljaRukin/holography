function [undistorted,ybegin,yend,xbegin,xend] = shift_image(distorted,original)

% correlation
c = normxcorr2(original,distorted);

% offset found by correlation
[max_c,imax] = max(abs(c(:)));
[ypeak,xpeak] = ind2sub(size(c),imax(1));
corr_offset = [(xpeak-size(original,2)) 
               (ypeak-size(original,1))];

fprintf('correlation maximum: %.3f \n',max_c);

% overlapping region
xbegin = round(corr_offset(1) + 1);
xend   = round(corr_offset(1) + size(original,2));
ybegin = round(corr_offset(2) + 1);
yend   = round(corr_offset(2) + size(original,1));

if (ybegin>0) && (xbegin>0) && (yend<size(distorted,1)) && (xend<size(distorted,2)) && (max_c>0.15)
    %cut out region
    undistorted = distorted(ybegin:yend,xbegin:xend);
else
    warning('correlation failed!');
    undistorted = 0;
end

end