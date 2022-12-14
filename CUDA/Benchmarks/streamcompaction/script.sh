#!/bin/bas
for((th=64; th<4097; th*=2)) 
do
	for ((co=8; co<th*4 && co<512; co*=2)) 
	do
		for i in $(seq 0 0.1 1) 
		do
			make clean
			nvcc -arch=sm_52 streamcompaction.cu -I/usr/local/cuda/include -lm -o streamcompaction -D INT -D COARSENING=$co -D THREADS=$th
	
			Throughput=$(./streamcompaction 0 $i 512000000 | grep Throughput | awk '{print $8}')
   			echo "$th, $co, $i, $Throughput"
			echo "$th, $co, $i, $Throughput" >> streamnonatomic.csv
		done
		echo " " >> streamnonatomic.csv
	done
done
