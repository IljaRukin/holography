function vec = wave_1d_multi(vec,trafo,iter)

vec_length = numel(vec);

for k=1:iter
    vec(1:vec_length/(2^(k-1))) = wave_trafo(vec(1:vec_length/(2^(k-1))),trafo);
end

end