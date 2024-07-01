CXX:=icpx

CXXFLAGS:=-O3 -xHost -qopenmp

SRCS:=./src/PIcalc.cpp
TARGET:=./exe/picalcexe

all: picalc

picalc:
	$(CXX) $(CXXFLAGS) -DLIKWID_PERFMON $(LIKWID_INC) $(SRCS) $(LIKWID_LIB) -llikwid -o $(TARGET)

clean:
	rm -rf exe simdata* *.png *.o*
