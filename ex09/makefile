CXX=icpx

CXXFLAGS=-O3 -xHost -qopenmp

SRCS=./src/histo.cpp
TARGET=./exe/histoexe

all : histo_atomic histo_red

histo_atomic :
	$(CXX) $(CXXFLAGS) $(SRCS) -Datomicupdate -o ./exe/histo_atomic

histo_red :
	$(CXX) $(CXXFLAGS) $(SRCS) -o ./exe/histo_red

clean:
	rm -rf exe simdata* *.png *.o*