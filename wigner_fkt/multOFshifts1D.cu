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
                      const unsigned int M ) {
    // current thread
    size_t const numel = M*M;
    int const idx = numel-1 - calculateGlobalIndex(); //optimize: reversed direction
    
    if (idx < 0){
        return;
    }

    // coordinates
    // W(fx,x)={{x} , {x}}
    //         | 0 fx  1 |
    int fx = idx/M; // [0,...0,1,...1,M-1,...M-1]
    int x = idx - fx*M; // [0,1,...,M-1,0,1,...,M-1,...]
    int xa = x +(fx-((float)M)/2);
    int xb = x -(fx-((float)M)/2);

    int idx2 = fx+M*x;
    if (idx2 >= numel){
        return;
    }
    //W[idx]->W(x,fx)
    //W[idx2]->W(fx,x)

    //shift & multiply
    if ( ( xa > -1 ) && ( xb > -1 ) && ( xa < M ) && ( xb < M ) ) {
        out[idx2] = cuCmulf( wavefield[xa] , cuConjf(wavefield[xb]) );
    }

    //test
//     out[idx] = make_cuFloatComplex((float)x,(float)fx);
//     out[idx].x = x; out[idx].y = fx;
//     out[idx] = make_cuFloatComplex((float)x,(float)(fx-((float)M)/2));
//     out[idx2] = make_cuFloatComplex((float)x,(float)fx);
//     out[idx2] = make_cuFloatComplex((float)x,(float)(fx-((float)M)/2));
}