function output = scaleValues(img,minv,maxv)
%scale values of array "img" to interval [minv,maxv]
if isreal(img)
    mini = min(img(:));
    maxi = max(img(:));
    output = (img-mini)/(maxi-mini) *(maxv-minv) +minv;
else
    amp = abs(img);
    mini = min(amp(:));
    maxi = max(amp(:));
    output = ((amp-mini)/(maxi-mini) *(maxv-minv) +minv) .* exp(1i*angle(img));
end
if mini==maxi
    warning('scaleValues: all values are equal!')
    output = maxv*complex(ones(size(img)));
end
end