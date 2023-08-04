function [R,normal_vec] = getRotation3D(q1,q2,q3)
%calculates rotation matrix to rotate triangle into a plane with z=constant

%normal vector
n = cross( q2-q1 , q3-q1 ); %vector normal to triangle surface
n = n/sqrt(sum(n.^2)); %normalize
%flip normal vector
if n(3)<0
    n = -n;
end
normal_vec = n;
% fprintf("%f %f %f\n",n);

%rotation around x-axis
theta1 = atan2(n(2),n(3));
% fprintf("%f\n",theta1);
R1 = [[1,0,0].',[0,cos(theta1),-sin(theta1)].',[0,sin(theta1),cos(theta1)].'].';
n = (R1)*n;

%rotation around y-axis
theta2 = -atan2(n(1),n(3));
% fprintf("%f\n",theta2);
R2 = [[cos(theta2),0,sin(theta2)].',[0,1,0].',[-sin(theta2),0,cos(theta2)].'].';
% n = (R2)*n;

R = R2*R1;

end