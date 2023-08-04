#include <cuComplex.h>
//stored in: C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.1\include\cuComplex.h

//determine block & thread, calculate unique index
__device__ size_t calculateGlobalIndex() {
    size_t const globalBlockIndex = blockIdx.x + blockIdx.y * gridDim.x;
    size_t const localThreadIdx = threadIdx.x + blockDim.x * threadIdx.y;
    size_t const threadsPerBlock = blockDim.x*blockDim.y;
    return localThreadIdx + globalBlockIndex*threadsPerBlock;
}

__global__ void main_func( 
                      const float2 * wavefield,
                      float2 * out,
                      const unsigned int M ,
                      const unsigned int N ) {
    // current thread
    size_t const numel = M*N*M*N;
    int const idx = numel-1 - calculateGlobalIndex(); //optimize: reversed direction
    
    if (idx < 0){
        return;
    }

    // coordinates
    // W(y,x,fy,fx)={{{{fx},{fx}},{{fx},{fx}}},{{{fx},{fx}},{{fx},{fx}}}}
    //                | 0 fy  1 |,| 0 fy  1 | , | 0 fy  1 |,| 0 fy  1 |
    //               |     0     x     1     |,|     0     x     1     |
    //              |            0            y            1            |
    int fx = idx/(N*M*N);
    int fy = idx/(M*N) - fx*(N);
    int x = idx/(N) - fx*(N*M) - fy*(M);
    int y = idx - fx*(N*M*N) - fy*(M*N) - x*(N);
//---
//     int fx = idx/(M*N);          = idx/(N*M*N);
//     int fy = idx/(M*N) - fx;     = idx/(M*N) - fx*(N);
//     int x = idx - fx*(M);        = idx/(N) - fx*(N*M) - fy*(M);
//     int y = idx - fx*(M) - x;    = idx - fx*(N*M*N) - fy*(M*N) - x*(N);
//---
    int xa = x +(fx-(float)(M/2));
    int xb = x -(fx-(float)(M/2));
    int ya = y +(fy-(float)(N/2));
    int yb = y -(fy-(float)(N/2));

    //W[idx]->W(y,x,fy,fx)
    //W[idx2]->W(fx,fy,x,y)
    int idx2 = fx+M*fy+N*M*x+M*N*M*y;
    if (idx2 >= numel){
        return;
    }

    //shift & multiply
    if ( ( xa > -1 ) && ( xb > -1 ) && ( ya > -1 ) && ( yb > -1 ) && ( xa < M ) && ( xb < M ) && ( ya < N ) && ( yb < N ) ) {
         out[idx2] = cuCmulf( wavefield[xa+ya*M] , cuConjf(wavefield[xb+yb*M]) );
    }

    //test
//     out[idx2] = make_cuFloatComplex((float)x,(float)y);
//     out[idx2] = make_cuFloatComplex((float)fx,(float)fy);
}