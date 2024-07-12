CXX=icpx

CXXFLAGS=-O3 -xHost -qopenmp

SRCS1=./src/histo_v1.cpp
SRCS2=./src/histo_v2.cpp

all : histo_atomic histo_red histov2

histo_v1 :
	$(CXX) $(CXXFLAGS) $(SRCS1) -o ./exe/histo_v1

histo_v2 :
	$(CXX) $(CXXFLAGS) $(SRCS2) -o ./exe/histo_v2

clean:
	rm -rf exe simdata* *.png *.o*