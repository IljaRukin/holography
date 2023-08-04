function [] = saveTTPAparams(fname, amp, piston, alphaX, alphaY, lambda, Dm, Dn)
% value ranges
% amp = [0,1]
% piston = [-pi,pi]
% alphaX,alphaY = [-2*pi/lambda/p,2*pi/lambda/p] (45° slope)

%test value range
if max(amp(:))>1 | min(amp(:))<0
    error('amplitude outside range');
end
if max(nosign(piston(:)))>pi
    error('piston outside range');
end
if max(nosign(alphaX(:))) > 2*pi/lambda/Dm
    error('alphaX outside range');
end
if max(nosign(alphaY(:))) > 2*pi/lambda/Dn
    error('alphaY outside range');
end

%rearrange to uint16 numbers (saves memory)
maxVal = 2^16-1;
amp = uint16(amp*maxVal);
piston = uint16(piston/(2*pi)*maxVal+(maxVal-1)/2);
alphaX = uint16((alphaX/(4*pi)*lambda*Dm)*maxVal+(maxVal-1)/2);
alphaY = uint16((alphaY/(4*pi)*lambda*Dn)*maxVal+(maxVal-1)/2);

save(fname, 'amp', 'piston', 'alphaX', 'alphaY');

end