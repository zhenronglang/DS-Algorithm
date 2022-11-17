#!/bin/bas
for((th=64; th<4097; th*=2)) 
do
	for ((co=8; co<th*4 && co<512; co*=2)) 
	do
		for i in $(seq 0 0.1 1) 
		do
			make clean
			nvcc -O3 -arch=sm_52 partition.cu -I/usr/local/cuda/include -lm -o partition -D COARSENING=32 -D THREADS=512 -D INT
			#Time=$(./streamcompaction 0 $i 8000000 | grep Throughput | awk '{print $4}')
			Throughput=$(./partition 0 $i 8000000 | grep Copy_if | awk '{print $10}')
   			echo "$th, $co, $i, $Throughput"
			echo "$th, $co, $i, $Throughput" >> selectlog.csv
		done
		echo " " >> selectlog.csv
	done
done
