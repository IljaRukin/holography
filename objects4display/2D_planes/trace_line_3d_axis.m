function points = trace_line_3d_axis(now,next,ax1,size)
%interpolate line (bresensham line algorithm)
%step along coordinate axis ax1 and correct the shorter sides
ax2 = mod(ax1,3)+1;
ax3 = mod(ax1+1,3)+1;
points = zeros(3,size);
points(:,1)=now;
d = next - now;
dir = sign(d);
d = abs(d);

overy = d(ax1) / 2;
overz = d(ax1) / 2;
for iii=1:d(ax1)
    now(ax1) = now(ax1) + dir(ax1);
    overy = overy + d(ax2);
    overz = overz + d(ax3);
    while overy >= d(ax1)
        overy = overy - d(ax1);
        now(ax2) = now(ax2) + dir(ax2);
    end
    while overz >= d(ax1)
        overz = overz - d(ax1);
        now(ax3) = now(ax3) + dir(ax3);
    end
    points(:,iii+1)=now;
end

end