function compressed = compress_real_fft_coeff( fft2_coeff )

%fft2 coefficients of real image --> reduced coefficient set

%format of reduced coeff array:
% #c#=one coefficient /// ---c--- multiple coefficients
% RE=real part /// IM=imaginary part
% #RE# ---RE--- #RE# ---IM---
%  |        ---RE---
%  |        ---RE---
%  RE       ---RE---
%  |        ---RE---
%  |        ---RE---
% #RE# ---RE--- #RE# ---IM---
%  |        ---IM---
%  |        ---IM---
%  IM       ---IM---
%  |        ---IM---
%  |        ---IM---


%dimensions
[N,M] = size(fft2_coeff);
N2 = ceil(N/2);
M2 = ceil(M/2);
N_even = (mod(N,2)==0);
M_even = (mod(M,2)==0);

compressed = zeros(N,M);

compressed(1,:) = [real(fft2_coeff(1,1:(M2+M_even))), imag(fft2_coeff(1,(M2+M_even+1):M))];
compressed(2:N2,:) = real(fft2_coeff(2:N2,:));
if N_even == 1
    compressed(N2+N_even,:) = [real(fft2_coeff(N2+N_even,1:(M2+N_even*M_even))), imag(fft2_coeff(N2+N_even,(M2+1+N_even*M_even):M))];
end
compressed((N2+1+N_even):N,:) = imag(fft2_coeff((N2+1+N_even):N,:));

end