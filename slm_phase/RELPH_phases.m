function [phi1,phi2] = RELPH_phases(E)
%calculate two phases for RELPH setup

%phi1 = angle(E) + atan(sqrt((4-abs(E.^2))./abs(E.^2)));
%phi2 = angle(E) - atan(sqrt((4-abs(E.^2))./abs(E.^2)));
phi1 = angle(E) + atan(sqrt(4./abs(E.^2)-1));
phi2 = angle(E) - atan(sqrt(4./abs(E.^2)-1));

phi1 = real(phi1);
phi2 = real(phi2);

end