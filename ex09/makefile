C=icx

CFLAGS=-O3 -xHost -qopenmp

SRCS1=./src/histo_v1.c
SRCS2=./src/histo_v2.c

all : histo_atomic histo_red histov2

histo_v1 :
	$(C) $(CFLAGS) $(SRCS1) -o ./exe/histo_v1

histo_v2 :
	$(C) $(CFLAGS) $(SRCS2) -o ./exe/histo_v2

clean:
	rm -rf exe simdata* *.png *.o*