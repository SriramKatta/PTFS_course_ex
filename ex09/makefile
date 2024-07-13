C=icx

CFLAGS=-O3 -xHost -qopenmp

SRCS1=./src/histo_v1.c
SRCS2=./src/histo_v2.c
SRCS3=./src/histo_v2_barrier_estimate.c

all : histo_v1 histo_v2 histo_v2_barrier_estimate

histo_v1 :
	$(C) $(CFLAGS) $(SRCS1) ./src/timing.c -o ./exe/histo_v1

histo_v2 :
	$(C) $(CFLAGS) $(SRCS2) ./src/timing.c -o ./exe/histo_v2

histo_v2_barrier_estimate :
	$(C) $(CFLAGS) $(SRCS3) ./src/timing.c -o ./exe/histo_v2_barrier_estimate

clean:
	rm -rf exe simdata* *.png *.o*