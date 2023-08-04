function [result] = wave_trafo(vec,trafo)
%forward wavelet transform
%some info: http://bearcave.com/misl/misl_tech/wavelets/daubechies/index.html
%more info: https://en.wikipedia.org/wiki/Daubechies_wavelet
%scaling fkt. (high pass filter) and wavelet fkt. (low pass filter) are quadrature mirror pairs,
%meaning fft(scaling(x)) = fft(wavelet(-x))
%therefore for n-th coeff: wavelet fkt. coeef_n = (-1)^n * scaling fkt. coeff_[(N-1)-n]

vec_length = numel(vec);

if trafo=='haar'
    %HAAR
    %[h0,h1]
    scaling = [1 1]'/sqrt(2);
    %[+h1,-h0]
    wavelet = [1 -1]'/sqrt(2);
elseif trafo=='db04'
    %DB4
    %[h0,h1,h2,h3]
    scaling = [+(1+sqrt(3)), +(3+sqrt(3)), +(3-sqrt(3)), +(1-sqrt(3))]'/(4*sqrt(2));
    %[g0,g1,g2,g3]=[+h3,-h2,+h1,-h0]
    wavelet = [+(1-sqrt(3)), -(3-sqrt(3)), +(3+sqrt(3)), -(1+sqrt(3))]'/(4*sqrt(2));
elseif trafo=='db04'
    %DB4
    %[h0,h1,h2,h3]
    scaling = [1,1]';
    %[g0,g1,g2,g3]=[+h3,-h2,+h1,-h0]
    wavelet = []';
end

trafo_length = numel(scaling);
overshoot = trafo_length-2;

if overshoot~=0
    %%%cyclic extension
    vec_extended = [vec,vec(1:overshoot)];
    %%%mirror at endpoint
    %vec_extended = [vec(overshoot:-1:1),vec,vec(vec_length:-1:vec_length-overshoot+1)];
    %vec_length = vec_length + 2;
else
    vec_extended = vec;
end

result=zeros(1,vec_length);

for n=1:vec_length/2
    result(n) = vec_extended(2*n-1:2*n+trafo_length-2) * scaling;
    result(vec_length/2+n) =  vec_extended(2*n-1:2*n+trafo_length-2) * wavelet;
end

end