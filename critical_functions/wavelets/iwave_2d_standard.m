function array = iwave_2d_standard(array,trafo,iter)

dim = size(array);

for n=1:dim(1)
    array(n,:) = iwave_1d_multi(array(n,:),trafo,iter(1));
end

for m=1:dim(2)
    array(:,m) = iwave_1d_multi(array(:,m)',trafo,iter(2));
end

end