#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <thrust/random.h>

int main() {
  // Generate 32M random numbers serially.
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
   





  // thrust::uniform_int_distribution<int> dist;
  //thrust::host_vector<int> h_vec(32 << 20);
  // thrust::generate(h_vec.begin(), h_vec.end(), [&] { return dist(rng); });
  // Transfer data to the device.
  thrust::device_vector<int> d_vec = h_vec;

  // Sort data on the device.
  thrust::sort(d_vec.begin(), d_vec.end());

  // Transfer data back to host.
  thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin());
}
