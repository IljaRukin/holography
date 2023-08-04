function array = wave_2d_standard(array,trafo,iter)

dim = size(array);

for n=1:dim(1)
    array(n,:) = wave_1d_multi(array(n,:),trafo,iter(1));
end

for m=1:dim(2)
    array(:,m) = wave_1d_multi(array(:,m)',trafo,iter(2));
end

end