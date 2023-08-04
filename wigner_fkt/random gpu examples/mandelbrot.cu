
//determine block & thread, calculate unique index
__device__ size_t calculateGlobalIndex() {
    size_t const globalBlockIndex = blockIdx.x + blockIdx.y * gridDim.x;
    size_t const localThreadIdx = threadIdx.x + blockDim.x * threadIdx.y;
    size_t const threadsPerBlock = blockDim.x*blockDim.y;
    return localThreadIdx + globalBlockIndex*threadsPerBlock;
}

// calculate mandelbrot set
__device__ unsigned int doIterations( float const x0,
                                      float const y0,
                                      unsigned int const maxIters ) {
    float xi = x0;
    float oldxi;
    float yi = y0;
    unsigned int counti = 1;

    // Loop until escape
    while ( ( counti <= maxIters ) && ((xi*xi + yi*yi) <= 4.0) ) {
        ++counti;
        oldxi = xi;
        // real part
        xi = xi*xi - yi*yi + x0;
        // imaginary part
        yi = 2*oldxi*yi + y0;
    }
    return counti;
}

// preprocess input
__global__ void main_func( 
                      unsigned int * out, 
                      const float * x, 
                      const float * y,
                      const unsigned int maxIters,
                      const unsigned int numel ) {
    // current thread
    size_t const idx = calculateGlobalIndex();

    // quit on thread overflow
    if (idx >= numel) {
        return;
    }
    
    // x,y coordinates
    float x0 = x[idx];
    float y0 = y[idx];

    // compute madelbrot set value
    unsigned int const count = doIterations( x0, y0, maxIters );
    out[idx] = count;
}