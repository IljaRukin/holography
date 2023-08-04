function [ U ] = trace_line(x,y,next_x,next_y,U)
%trace 2D line from (y,x) to (next_y,next_x) on image U using Bresenham-Algorithmus

% x = int32(x);
% y = int32(y);
% next_x = int32(next_x);
% next_y = int32(next_y);

U(y,x,1)=1;
over = 0;
dx = next_x - x;
dy = next_y - y;
dirx = sign(dx);
diry = sign(dy);
dx = abs(dx);
dy = abs(dy);

if dx > dy
    over = dx / 2;
    for i = 1:dx
        x = x + dirx;
        over = over + dy;
        if over >= dx
            over = over - dx;
            y = y + diry;
        end
    U(y,x,1)=1;
    end
else
    over = dy / 2;
    for iii = 1:dy
        y = y + diry;
        over = over + dx;
        if over >= dy
            over = over -dy;
            x = x + dirx;
        end
    U(y,x,1)=1;
    end
end

end

