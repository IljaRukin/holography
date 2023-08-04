function decompressed = decompress_real_fft_coeff( compressed )

%reduced coefficient set --> original fft2 coefficients of real image

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
[N,M] = size(compressed);
N2 = ceil(N/2);
M2 = ceil(M/2);
N_even = (mod(N,2)==0);
M_even = (mod(M,2)==0);

decompressed = zeros(N,M);

if N_even == 1
    if M_even == 1
        % M even && N even
        decompressed(1,:) = [compressed(1,1:(M2+M_even)), compressed(1,M2:-1:2)] + 1i*[ 0 , -1*compressed(1,M:-1:(M2+M_even+1)) , 0 , compressed(1,(M2+M_even+1):M)];
        decompressed(2:end,1) = [compressed(2:(N2+N_even),1).', compressed(N2:-1:2,1).'] + 1i*[ -1*compressed(N:-1:(N2+N_even+1),1).' , 0 , compressed((N2+N_even+1):N,1).'];
        decompressed(N2+N_even,2:end) = [compressed(N2+N_even,2:(M2+M_even)), compressed(N2+N_even,M2:-1:2)] + 1i*[ -1*compressed(N2+N_even,M:-1:(M2+M_even+1)) , 0 , compressed(N2+N_even,(M2+M_even+1):M)];
    else
        % M odd && N even
        decompressed(1,:) = [compressed(1,1:(M2+M_even)), compressed(1,M2:-1:2)] + 1i*[ 0 , -1*compressed(1,M:-1:(M2+M_even+1)) , compressed(1,(M2+M_even+1):M)];
        decompressed(2:end,1) = [compressed(2:(N2+N_even),1).', compressed(N2:-1:2,1).'] + 1i*[ -1*compressed(N:-1:(N2+N_even+1),1).' , 0 , compressed((N2+N_even+1):N,1).'];
        decompressed(N2+N_even,2:end) = [compressed(N2+N_even,2:(M2+M_even)), compressed(N2+N_even,M2:-1:2)] + 1i*[ -1*compressed(N2+N_even,M:-1:(M2+M_even+1)) , compressed(N2+N_even,(M2+M_even+1):M)];
    end
else
    if M_even == 1
        % M even && N odd
        decompressed(1,:) = [compressed(1,1:(M2+M_even)), compressed(1,M2:-1:2)] + 1i*[ 0 , -1*compressed(1,M:-1:(M2+M_even+1)) , 0 , compressed(1,(M2+M_even+1):M)];
        decompressed(2:end,1) = [compressed(2:(N2+N_even),1).', compressed(N2:-1:2,1).'] + 1i*[ -1*compressed(N:-1:(N2+N_even+1),1).' , compressed((N2+N_even+1):N,1).'];
    else
        % M odd && N odd
        decompressed(1,:) = [compressed(1,1:(M2+M_even)), compressed(1,M2:-1:2)] + 1i*[ 0 , -1*compressed(1,M:-1:(M2+M_even+1)) , compressed(1,(M2+M_even+1):M)];
        decompressed(2:end,1) = [compressed(2:(N2+N_even),1).', compressed(N2:-1:2,1).'] + 1i*[ -1*compressed(N:-1:(N2+N_even+1),1).' , compressed((N2+N_even+1):N,1).'];
    end
end

decompressed(2:N2,2:end) = compressed(2:N2,2:end) - 1i*rot90(compressed((N2+1+N_even):end,2:end),2);
decompressed((N2+1+N_even):end,2:end) = rot90(compressed(2:N2,2:end),2) + 1i*compressed((N2+1+N_even):end,2:end);

end