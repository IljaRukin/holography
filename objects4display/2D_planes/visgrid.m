function [img] = visgrid(M,N,Mslm,Nslm)
%visibility grid

if nargin < 1
    M = 2048;
end
if nargin < 2
    N = 2048;
end
if nargin < 3
    Mslm = 1920;
end
if nargin < 4
    Nslm = 1080;
end
MMslm = Nslm -600; %480px
NNslm = Mslm -1200; %720px

%visebility grid
 = zeros(N,M,1);
U(1,:,1) = 1;
U(2,:,1) = 1;
U(3,:,1) = 1;
U(N,:,1) = 1;
U(N-1,:,1) = 1;
U(N-2,:,1) = 1;
U(:,1,1) = 1;
U(:,2,1) = 1;
U(:,3,1) = 1;
U(:,M,1) = 1;
U(:,M-1,1) = 1;
U(:,M-2,1) = 1;
U(round((N-Nslm)/2),:,1) = 1;
U(round((N-Nslm)/2)-1,:,1) = 1;
U(round((N-Nslm)/2)+1,:,1) = 1;
U(round((N-Nslm)/2)+Nslm,:,1) = 1;
U(round((N-Nslm)/2)+Nslm-1,:,1) = 1;
U(round((N-Nslm)/2)+Nslm+1,:,1) = 1;
U(:,round((M-Mslm)/2),1) = 1;
U(:,round((M-Mslm)/2)-1,1) = 1;
U(:,round((M-Mslm)/2)+1,1) = 1;
U(:,round((M-Mslm)/2)+Mslm,1) = 1;
U(:,round((M-Mslm)/2)+Mslm-1,1) = 1;
U(:,round((M-Mslm)/2)+Mslm+1,1) = 1;
p1=[1,1];p2=[round((M-Mslm)/2),round((N-Nslm)/2)+Nslm];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U = trace_line(p1(1)+3,p1(2),p2(1)+3,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
p1=[1,1];p2=[round((M-Mslm)/2)+Mslm,round((N-Nslm)/2)];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U = trace_line(p1(1)+3,p1(2),p2(1)+3,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U = trace_line(p1(1)+4,p1(2),p2(1)+4,p2(2),U);
U = trace_line(p1(1)+5,p1(2),p2(1)+5,p2(2),U);
p1=[N,M];p2=[round((M-Mslm)/2),round((N-Nslm)/2)+Nslm];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)-1,p1(2),p2(1)-1,p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)-2,p1(2),p2(1)-2,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U = trace_line(p1(1)+3,p1(2),p2(1)+3,p2(2),U);
U = trace_line(p1(1)+4,p1(2),p2(1)+4,p2(2),U);
p1=[N,M];p2=[round((M-Mslm)/2)+Mslm,round((N-Nslm)/2)];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)-1,p1(2),p2(1)-1,p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)-2,p1(2),p2(1)-2,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U(round((N-MMslm)/2),:,1) = 1;
U(round((N-MMslm)/2)-1,:,1) = 1;
U(round((N-MMslm)/2)+1,:,1) = 1;
U(round((N-MMslm)/2)+MMslm,:,1) = 1;
U(round((N-MMslm)/2)+MMslm-1,:,1) = 1;
U(round((N-MMslm)/2)+MMslm+1,:,1) = 1;
U(:,round((M-NNslm)/2),1) = 1;
U(:,round((M-NNslm)/2)-1,1) = 1;
U(:,round((M-NNslm)/2)+1,1) = 1;
U(:,round((M-NNslm)/2)+NNslm,1) = 1;
U(:,round((M-NNslm)/2)+NNslm-1,1) = 1;
U(:,round((M-NNslm)/2)+NNslm+1,1) = 1;
p1=[1,1];p2=[round((M-NNslm)/2),round((N-MMslm)/2)+MMslm];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U = trace_line(p1(1)+3,p1(2),p2(1)+3,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
p1=[1,1];p2=[round((M-NNslm)/2)+NNslm,round((N-MMslm)/2)];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
U = trace_line(p1(1)+3,p1(2),p2(1)+3,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
p1=[N,M];p2=[round((M-NNslm)/2),round((N-MMslm)/2)+MMslm];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)-1,p1(2),p2(1)-1,p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)-2,p1(2),p2(1)-2,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);
p1=[N,M];p2=[round((M-NNslm)/2)+NNslm,round((N-MMslm)/2)];
U = trace_line(p1(1),p1(2),p2(1),p2(2),U);
U = trace_line(p1(1)-1,p1(2),p2(1)-1,p2(2),U);
U = trace_line(p1(1)+1,p1(2),p2(1)+1,p2(2),U);
U = trace_line(p1(1)-2,p1(2),p2(1)-2,p2(2),U);
U = trace_line(p1(1)+2,p1(2),p2(1)+2,p2(2),U);

end

