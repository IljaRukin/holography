function grid = trace_line_3d(now,next,grid)
%interpolate line (bresensham line algorithm)
%step along the long side and correct both shorter sides
grid(now(1),now(2),now(3)) = true;
d = next - now;
dir = sign(d);
d = abs(d);

if (d(1) > d(2))
    if (d(1) > d(3))
        if (d(2) > d(3))
            i = 1; j = 2; k = 3;
        else
            i = 1; j = 3; k = 2;
        end
    else
        i = 3; j = 1; k = 2;
    end
else
    if (d(2) > d(3))
        if (d(1) > d(3))
            i = 2; j = 1; k = 3;
        else
            i = 2; j = 3; k = 1;
        end
    else
            i = 3; j = 2; k = 1;
    end
end

overj = d(i) / 2;
overk = d(j) / 2;
for iii=1:d(i)
    now(i) = now(i) + dir(i);
    overj = overj + d(j);
    if (overj >= d(i))
        overj = overj - d(i);
        now(j) = now(j) + dir(j);
        overk = overk + d(k);
        grid(now(1),now(2),now(3)) = true;
        if (overk >= d(j))
            overk = overk - d(j);
            now(k) = now(k) + dir(k);
            grid(now(1),now(2),now(3)) = true;
        end
    end
    grid(now(1),now(2),now(3)) = true;
end

end