#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <thrust/random.h>
#include <thrust/partition.h>
#include <time.h>
#include <stdio.h>
#include <vector>

#define T int
#define WARMUP 2
#define REP 10

struct is_even{
    __host__ __device__
    bool operator()(const T &x){
      return (x % 2) == 0;
    }
  };



int main(){

    

    for (int i = 0; i < 100; i +=10){


        int input = i;
        int numElements = 8000000;
        size_t size = numElements * sizeof(T);
        cudaSetDevice(0);

        cudaEvent_t start, stop;
        cudaEventCreate(&start);
        cudaEventCreate(&stop);
        float time1 = 0;
        float time2 = 0;



        for(int iteration = 0; iteration < REP+WARMUP; iteration++){

            
            // Initialize the host input vectors
            thrust::host_vector<T> h_vec(numElements);
            thrust::detail::normal_iterator<T *> h_A = h_vec.begin();

            srand(2014);
            for(int i = 0; i < numElements; i++)
                h_A[i] = i % 2 != 0 ? i:i+1;
            int M = (numElements * input)/100;
            int m = M;
            while(m>0){
                int x = (int)(numElements*(((float)rand()/(float)RAND_MAX)));
                if(h_A[x] % 2 != 0){
                    h_A[x] = x * 2;
                    m--;
                }
            }
            
            thrust::device_vector<int> d_vec = h_vec;
            thrust::device_vector<int> s_vec = h_vec;

            //measure performance
        
            cudaEventRecord( start, 0 );

            thrust::partition(d_vec.begin(), d_vec.end(), s_vec.begin(), is_even());

            cudaDeviceSynchronize();
            cudaEventRecord(stop, 0);
            cudaEventSynchronize(stop);
            cudaEventElapsedTime(&time1, start, stop);
            if(iteration >= WARMUP) time2 += time1;
            
            if(iteration == REP+WARMUP-1){
                float timer = time2 / REP;
                double bw = (double)((2 * numElements) * sizeof(T)) / (double)(timer * 1000000.0);
                FILE *fpt;
                fpt = fopen("hype.csv", "a");
                fprintf(fpt, "%d, %f, %f\n", input, timer, bw);
                fclose(fpt);
            }
        
        }
    }
    
    return 0;

}

