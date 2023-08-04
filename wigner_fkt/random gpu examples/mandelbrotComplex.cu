
#include <cuComplex.h>
//stored in: C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.1\include\cuComplex.h
//#include <thrust/complex.h>
//thrust::complex<float>

//determine block & thread, calculate unique index
__device__ size_t calculateGlobalIndex() {
    size_t const globalBlockIndex = blockIdx.x + blockIdx.y * gridDim.x;
    size_t const localThreadIdx = threadIdx.x + blockDim.x * threadIdx.y;
    size_t const threadsPerBlock = blockDim.x*blockDim.y;
    return localThreadIdx + globalBlockIndex*threadsPerBlock;
}

//x^2
__host__ __device__ static __inline__ float squaref (float x)
{
    float square;
    square = x*x;
    return square;
}

//z^2
__host__ __device__ static __inline__ cuFloatComplex cuCsquaref (cuFloatComplex z)
{
    cuFloatComplex square;
    square = make_cuFloatComplex( squaref(cuCrealf(z)) - squaref(cuCimagf(z)), 2*cuCrealf(z)*cuCimagf(z) );
    return square;
}

//|z|^2
__host__ __device__ static __inline__ float cuCabs2f (cuFloatComplex z)
{
    float abs2;
    abs2 = squaref(cuCrealf(z)) + squaref(cuCimagf(z));
    return abs2;
}

// calculate mandelbrot set
__device__ unsigned int doIterations( const float2 z0,
                                      unsigned int const maxIters ) {
    float2 z = z0;
    unsigned int counti = 1;

    // Loop until escape
    //while ( ( counti <= maxIters ) && (cuCrealf( cuCmulf( cuConjf(z) , z ) ) <= 4.0) ) {
    while ( ( counti <= maxIters ) && (cuCabs2f(z) <= 4.0) ) {
        ++counti;
        //z = cuCaddf( cuCmulf( z , z ) , z0 );
        z = cuCaddf( cuCsquaref( z ) , z0 );
    }
    return counti;
}

// preprocess input
//float2 is identical to cuFloatComplex
__global__ void main_func( 
                      unsigned int * out, 
                      const float2 * z,
                      const unsigned int maxIters,
                      const unsigned int numel ) {
    // current thread
    size_t const idx = calculateGlobalIndex();

    // quit on thread overflow
    if (idx >= numel) {
        return;
    }

    // compute madelbrot set value
    out[idx] = doIterations( z[idx], maxIters );
}