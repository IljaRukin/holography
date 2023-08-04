//#include "mex.h"

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <helper_functions.h>
#include <helper_cuda.h>

#include <ctime>
#include <time.h>
#include <stdio.h>
#include <iostream>
#include <math.h>
#include <cufft.h>
#include <fstream>

__global__ void main_func(float2 * signal,
                        const unsigned int M,
                        const unsigned int N)
{
	// CUFFT plan
	cufftHandle plan;
	cufftPlan2d(&plan, M, N, CUFFT_C2C);

	// FFT
	cufftExecC2C(plan, (cufftComplex *)signal, (cufftComplex *)signal, CUFFT_FORWARD); //CUFFT_INVERSE

}