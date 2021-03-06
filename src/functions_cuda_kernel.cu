#include <stdbool.h>
#include <stdio.h>
#include "functions_cuda_kernel.h"
#include "internals.h"

#define real float
#define NUM_BLOCKS 256

// there's a way to write shorter code by templating float/double, but without knowing much about template overhead (which I think is small, but not certain) I'm just going to reimplement + vim

__global__ void polygamma_cuda_kernel(int n, int input_sheight, int input_swidth, int output_sheight, int output_swidth, int height, int width, float *input_data, float *output_data) {
  for (int addr = threadIdx.x; addr < width * height; addr += blockDim.x)
    output_data[addr] = polygamma_impl(n, input_data[addr]);
}

__global__ void lgamma_cuda_kernel(int input_sheight, int input_swidth, int output_sheight, int output_swidth, int height, int width, float *input_data, float *output_data) {
  for (int addr = threadIdx.x; addr < width * height; addr += blockDim.x)
    output_data[addr] = lgamma(input_data[addr]);
}

__global__ void lbeta_cuda_kernel(int a_sheight, int a_swidth, int b_sheight, int b_swidth, int output_sheight, int output_swidth, int height, int width, float *a_data, float *b_data, float *output_data) {
  for (int addr = threadIdx.x; addr < width * height; addr += blockDim.x)
    output_data[addr] = lbeta_impl(a_data[addr], b_data[addr]);
}

__global__ void polygamma_cuda_dbl_kernel(int n, int input_sheight, int input_swidth, int output_sheight, int output_swidth, int height, int width, double *input_data, double *output_data) {
  for (int addr = threadIdx.x; addr < width * height; addr += blockDim.x)
    output_data[addr] = polygamma_impl_dbl(n, input_data[addr]);
}

__global__ void lgamma_cuda_dbl_kernel(int input_sheight, int input_swidth, int output_sheight, int output_swidth, int height, int width, double *input_data, double *output_data) {
  for (int addr = threadIdx.x; addr < width * height; addr += blockDim.x)
    output_data[addr] = lgamma(input_data[addr]);
}

__global__ void lbeta_cuda_dbl_kernel(int a_sheight, int a_swidth, int b_sheight, int b_swidth, int output_sheight, int output_swidth, int height, int width, double *a_data, double *b_data, double *output_data) {
  for (int addr = threadIdx.x; addr < width * height; addr += blockDim.x)
    output_data[addr] = lbeta_impl_dbl(a_data[addr], b_data[addr]);
}

#ifdef __cplusplus
extern "C" {
#endif

int polygamma_cuda_wrapped(int n, int input_strideHeight, int input_strideWidth, int output_strideHeight, int output_strideWidth, int height, int width, float *input_data, float *output_data) {
  polygamma_cuda_kernel<<<1, NUM_BLOCKS>>>(n, input_strideHeight, input_strideWidth, output_strideHeight, output_strideWidth, height, width, input_data, output_data);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    printf("error in polygamma_cuda_kernel: %s\n", cudaGetErrorString(err));
    return 1;
  }
  return 0;
}

int lgamma_cuda_wrapped(int input_strideHeight, int input_strideWidth, int output_strideHeight, int output_strideWidth, int height, int width, float *input_data, float *output_data) {
  lgamma_cuda_kernel<<<1, NUM_BLOCKS>>>(input_strideHeight, input_strideWidth, output_strideHeight, output_strideWidth, height, width, input_data, output_data);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    printf("error in lgamma_cuda_kernel: %s\n", cudaGetErrorString(err));
    return 1;
  }
  return 0;
}

int lbeta_cuda_wrapped(int a_strideHeight, int a_strideWidth, int b_strideHeight, int b_strideWidth, int output_strideHeight, int output_strideWidth, int height, int width, float *a_data, float *b_data, float *output_data) {
  lbeta_cuda_kernel<<<1, NUM_BLOCKS>>>(a_strideHeight, a_strideWidth, b_strideHeight, b_strideWidth, output_strideHeight, output_strideWidth, height, width, a_data, b_data, output_data);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    printf("error in lbeta_cuda_kernel: %s\n", cudaGetErrorString(err));
    return 1;
  }
  return 0;
}

int polygamma_cuda_dbl_wrapped(int n, int input_strideHeight, int input_strideWidth, int output_strideHeight, int output_strideWidth, int height, int width, double *input_data, double *output_data) {
  polygamma_cuda_dbl_kernel<<<1, NUM_BLOCKS>>>(n, input_strideHeight, input_strideWidth, output_strideHeight, output_strideWidth, height, width, input_data, output_data);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    printf("error in polygamma_cuda_dbl_kernel: %s\n", cudaGetErrorString(err));
    return 1;
  }
  return 0;
}

int lgamma_cuda_dbl_wrapped(int input_strideHeight, int input_strideWidth, int output_strideHeight, int output_strideWidth, int height, int width, double *input_data, double *output_data) {
  lgamma_cuda_dbl_kernel<<<1, NUM_BLOCKS>>>(input_strideHeight, input_strideWidth, output_strideHeight, output_strideWidth, height, width, input_data, output_data);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    printf("error in lgamma_cuda_dbl_kernel: %s\n", cudaGetErrorString(err));
    return 1;
  }
  return 0;
}

int lbeta_cuda_dbl_wrapped(int a_strideHeight, int a_strideWidth, int b_strideHeight, int b_strideWidth, int output_strideHeight, int output_strideWidth, int height, int width, double *a_data, double *b_data, double *output_data) {
  lbeta_cuda_dbl_kernel<<<1, NUM_BLOCKS>>>(a_strideHeight, a_strideWidth, b_strideHeight, b_strideWidth, output_strideHeight, output_strideWidth, height, width, a_data, b_data, output_data);

  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    printf("error in lbeta_cuda_dbl_kernel: %s\n", cudaGetErrorString(err));
    return 1;
  }
  return 0;
}

#ifdef __cplusplus
}
#endif
