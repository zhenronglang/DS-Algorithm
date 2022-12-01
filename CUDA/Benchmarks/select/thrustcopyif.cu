#include <stdio.h>
#include <time.h>
#include <vector>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>

#define T int
#define WARMUP 2
#define REP 10

int main()
{
	for (float i = 0.0; i < 1.05; i += 0.1)
	{
		float input = i;
		int numElements = 16000000;
		size_t size = numElements * sizeof(T);

		int value = 0;
		cudaSetDevice(0);

		cudaEvent_t start, stop;
		cudaEventCreate(&start);
		cudaEventCreate(&stop);
		float time1 = 0;
		float time2 = 0;

		for (int iteration = 0; iteration < REP + WARMUP; iteration++)
		{

			thrust::host_vector<T> h_vec(size);
			thrust::detail::normal_iterator<T *> h_A = h_vec.begin();

			srand(2014);
			for (int i = 0; i < numElements; i++)
				h_A[i] = value;
			int M = (numElements * input) / 100;
			int m = M;
			while (m > 0)
			{
				int x = (int)(numElements * (((float)rand() / (float)RAND_MAX)));
				if (h_A[x] == value)
				{
					h_A[x] = x + 2;
					m--;
				}
			}

			thrust::device_vector<int> d_vec = h_vec;
			thrust::device_vector<int> s_vec = h_vec;

			cudaEventRecord(start, 0);

			thrust::copy_if(d_vec.begin(), d_vec.end(), s_vec.begin(), is_even());

			cudaDeviceSynchronize();
			cudaEventRecord(stop, 0);
			cudaEventSynchronize(stop);
			cudaEventElapsedTime(&time1, start, stop);
			if (iteration >= WARMUP)
				time2 += time1;

			if (iteration == REP + WARMUP - 1)
			{
				float timer = time2 / REP;
				double bw = (double)((2 * numElements) * sizeof(T)) / (double)(timer * 1000000.0);
				printf("%f, %f, %f\n", input, timer, bw);
			}
		}
	}
	return 0;
}
