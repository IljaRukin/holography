function [offset] = calc_offset(phases)
%callculates average of phases while taking modulo 2pi into account.
%this is done by testing multiple phase offsets and return the one wich has
%smallest absolute error modulo 2pi to provided phases.

minError = pi;
N = numel(phases);
%offsetArray = linspace(-pi,pi,N);
offsetArray = phases;
offset = pi;
for k=1:N
    error = mean(mean( abs( mod(phases-(offsetArray(k)+1e-10)+pi,2*pi)-pi ) ));
    if error< minError
        %fprintf("%f - %f \n",error,offset);
        minError = error;
        offset = phases(k)+1e-10;
    end
end
end
