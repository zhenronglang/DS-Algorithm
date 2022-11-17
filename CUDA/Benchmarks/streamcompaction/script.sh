#!/bin/bas
for((th=64; th<4097; th*=2)) 
do
	for ((co=8; co<th*4 && co<512; co*=2)) 
	do
		for i in $(seq 0 0.1 1) 
		do
			make clean
			nvcc -arch=sm_52 streamcompaction.cu -I/usr/local/cuda/include -lm -o streamcompaction -D FLOAT -D COARSENING=$co -D THREADS=$th
	
			#Time=$(./streamcompaction 0 $i 8000000 | grep Throughput | awk '{print $4}')
			Throughput=$(./streamcompaction 0 $i 2048000000 | grep Throughput | awk '{print $8}')
   			echo "$th, $co, $i, $Throughput"
			echo "$th, $co, $i, $Throughput" >> streamcompactionlog.csv
		done
		echo " " >> log1.csv
	done
done
