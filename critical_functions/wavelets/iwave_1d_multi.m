function vec = iwave_1d_multi(vec,trafo,iter)

vec_length = numel(vec);

for k=1:iter
    vec(1:vec_length/(2^(iter-k))) = iwave_trafo(vec(1:vec_length/(2^(iter-k))),trafo);
end

end