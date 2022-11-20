#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <thrust/random.h>

int main() {

  
  cudaEvent_t start, stop;
  // Allocate the host input vector A
  int *h_A = (int*)malloc(512000000 * sizeof(int));


  int value = 0;
  int numElements = 8000000;
  float input = 0.1;
  srand(2014);
    for(int i = 0; i < numElements; i++)
        h_A[i] = value;
    int M = (numElements * input)/100;
    int m = M;
    while(m>0){
        int x = (int)(numElements*(((float)rand()/(float)RAND_MAX)));
        if(h_A[x]==value){
            h_A[x] = x+2;
            m--;
        }
    }
    cudaEventCreate(&start);
    cudaEventCreate(&stop);






  // Transfer data to the device.
  thrust::device_vector<int> d_vec = h_vec;

  // Sort data on the device.
  thrust::sort(d_vec.begin(), d_vec.end());

  // Transfer data back to host.
  thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin());
}
