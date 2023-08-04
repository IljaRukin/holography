#include<iostream>

void trace_line_2d(float x, float y, float next_x, float next_y) {
    std::cout << x << ", " << y << "\n";
    //interpolate line (bresensham line algorithm)
    //step along the long side and correct the shorter side
    //variable notation
    long iii = 0;
    long over;
    long dx = next_x - x;
    long dy = next_y - y;
    int dirx = dx > 0 ? 1 : -1;
    int diry = dy > 0 ? 1 : -1;
    dx = abs(dx);
    dy = abs(dy);

    if (dx > dy) {
        over = dx / 2;
        for (i = 0; i < dx; i++) {
            x += dirx;
            over += dy;
            if (over >= dx) {
                over -= dx;
                y += diry;
            }
            std::cout << x << ", " << y << "\n";
        }
    }
    else {
        over = dy / 2;
        for (iii = 0; iii < dy; iii++) {
            y += diry;
            over += dx;
            if (over >= dy) {
                over -= dy;
                x += dirx;
            }
            std::cout << x << ", " << y << "\n";
        }
    }
    return;
}

int main(void)
{
    trace_line_2d(3,7,8,-3);
}

//----------

#include<iostream>

void trace_line_2d(float * now, float *next) {
    std::cout << now[0] << ", " << now[1] << "\n";
    //interpolate line (bresensham line algorithm)
    //step along the long side and correct the shorter side
    //array notation
    long iii = 0;
    long over;
    long d[2];
    d[0] = next[0] - now[0];
    d[1] = next[1] - now[1];
    int dir[2];
    dir[0] = d[0] > 0 ? 1 : -1;
    dir[1] = d[1] > 0 ? 1 : -1;
    d[0] = abs(d[0]);
    d[1] = abs(d[1]);

    uint16_t i,j;
    if (d[0] > d[1]) {i = 0;j = 1;}
    else {i = 1;j = 0;}

    over = d[i] / 2;
    for (iii = 0; iii < d[i]; iii++) {
        now[i] += dir[i];
        over += d[j];
        if (over >= d[i]) {
            over -= d[i];
            now[j] += dir[j];
        }
        std::cout << now[0] << ", " << now[1] << "\n";
    }
    return;
}

int main(void)
{
    float now[2] = { 8, -3 };
    float next[2] = { 3, 7 };
    trace_line_2d(now, next);
}

//----------

#include<iostream>

void trace_line_3d_xaxis(float next_x, float next_y, float next_z, float x, float y, float z) {
    std::cout << x << ", " << y << ", " << z << "\n";
    //interpolate line (bresensham line algorithm)
    //step along x axis and correct the two sides
    //variable notation
    long iii = 0;
    long overy;
    long overz;
    long dx = next_x - x;
    long dy = next_y - y;
    long dz = next_z - z;
    int dirx = dx > 0 ? 1 : -1;
    int diry = dy > 0 ? 1 : -1;
    int dirz = dz > 0 ? 1 : -1;
    dx = abs(dx);
    dy = abs(dy);
    dz = abs(dy);

    overy = dx / 2;
    overz = dx / 2;
    for (iii = 0; iii < dx; iii++) {
        x += dirx;
        overy += dy;
        overz += dz;
        while (overy >= dx) {
            overy -= dx;
            y += diry;
        }
        while (overz >= dx) {
            overz -= dx;
            z += dirz;
        }
        std::cout << x << ", " << y << ", " << z << "\n";
    }
    return;
}

int main(void)
{
    trace_line_3d_xaxis(3, 7, 9, 8, -3, 6);
}

//----------

#include<iostream>

void trace_line_3d_xaxis(float *now, float *next) {
    std::cout << now[0] << ", " << now[1] << ", " << now[2] << "\n";
    //interpolate line (bresensham line algorithm)
    //step along x axis and correct the shorter side
    //array notation
    long iii = 0;
    long overy;
    long overz;
    long d[3];
    d[0] = next[0] - now[0];
    d[1] = next[1] - now[1];
    d[2] = next[2] - now[2];
    int dir[3];
    dir[0] = d[0] > 0 ? 1 : -1;
    dir[1] = d[1] > 0 ? 1 : -1;
    dir[2] = d[2] > 0 ? 1 : -1;
    d[0] = abs(d[0]);
    d[1] = abs(d[1]);
    d[2] = abs(d[2]);

    overy = d[0] / 2;
    overz = d[0] / 2;
    for (iii = 0; iii < d[0]; iii++) {
        now[0] += dir[0];
        overy += d[1];
        overz += d[2];
        while (overy >= d[0]) {
            overy -= d[0];
            now[1] += dir[1];
        }
        while (overz >= d[0]) {
            overz -= d[0];
            now[2] += dir[2];
        }
        std::cout << now[0] << ", " << now[1] << ", " << now[2] << "\n";
    }
    return;
}

int main(void)
{
    float now[3] = { 8, -3, 5 };
    float next[3] = { 3, 7, -2 };
    trace_line_3d_xaxis(now, next);
}

//----------

#include<iostream>

void trace_line_3d(float * now, float *next) {
    std::cout << now[0] << ", " << now[1] << ", " << now[2] << "\n";
    //interpolate line (bresensham line algorithm)
    //step along the long side and corrects both shorter sides
    long iii = 0;
    long overj;
    long overk;
    long d[3];
    d[0] = next[0] - now[0];
    d[1] = next[1] - now[1];
    d[2] = next[2] - now[2];
    int dir[3];
    dir[0] = d[0] > 0 ? 1 : -1;
    dir[1] = d[1] > 0 ? 1 : -1;
    dir[2] = d[2] > 0 ? 1 : -1;
    d[0] = abs(d[0]);
    d[1] = abs(d[1]);
    d[2] = abs(d[2]);

    uint16_t i,j,k;
    if (d[0] > d[1]) {
        if (d[0] > d[2]) {
            if (d[1] > d[2]) {
                i = 0; j = 1; k = 2;
            }
            else {
                i = 0; j = 2; k = 1;
            }
        }
        else {
            i = 2; j = 0; k = 1;
        }
    }
    else {
        if (d[1] > d[2]) {
            if (d[0] > d[2]) {
                i = 1; j = 0; k = 2;
            }
            else {
                i = 1; j = 2; k = 0;
            }
        }
        else {
                i = 2; j = 1; k = 0;
        }
    }

    overj = d[i] / 2;
    overk = d[j] / 2;
    for (iii = 0; iii < d[i]; iii++) {
        now[i] += dir[i];
        overj += d[j];
        if (overj >= d[i]) {
            overj -= d[i];
            now[j] += dir[j];
            overk += d[k];
            if (overk >= d[j]) {
                overk -= d[j];
                now[k] += dir[k];
            }
        }
        std::cout << now[0] << ", " << now[1] << ", " << now[2] << "\n";
    }
    return;
}

int main(void)
{
    float now[3] = { 8, -3, 5 };
    float next[3] = { 3, 7, -2 };
    trace_line_3d(now, next);
}
