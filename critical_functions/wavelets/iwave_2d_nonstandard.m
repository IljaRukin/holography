function array = iwave_2d_nonstandard(array,trafo,iter)

dim = size(array);

for iii=1:iter
    %vec(1:vec_length/(2^(iii-1))) =  (vec(1:vec_length/(2^(iii-1))),trafo);
    %vec(1:vec_length/(2^(decompose_nr-iii))) = iwave_trafo(vec(1:vec_length/(2^(decompose_nr-iii))),trafo);
    ll = 2^(iter-iii);
    for n=1:dim(1)/ll
        array(n,1:dim(1)/ll) = iwave_trafo(array(n,1:dim(1)/ll),trafo);
    end
    for m=1:dim(2)/ll
        array(1:dim(2)/ll,m) = iwave_trafo(array(1:dim(2)/ll,m)',trafo);
    end
end

end