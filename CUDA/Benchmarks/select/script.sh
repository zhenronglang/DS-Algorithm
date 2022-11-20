#!/bin/bas
for((th=64; th<4097; th*=2)) 
do
	for ((co=8; co<th*4 && co<512; co*=2)) 
	do
		for i in $(seq 0 0.1 1) 
		do
			make clean
			nvcc -O3 -arch=sm_52 select.cu -I/usr/local/cuda/include -lm -o select -D atom -D COARSENING=$co -D THREADS=$th -D INT  	

			#Time=$(./streamcompaction 0 $i 8000000 | grep Throughput | awk '{print $4}')
			Throughput=$(./select 0 $i 512000000 | grep Copy_if | awk '{print $10}')
   			echo "$th, $co, $i, $Throughput"
			echo "$th, $co, $i, $Throughput" >> selectatomic.csv
		done
		echo " " >> selectatomic.csv
	done
done
