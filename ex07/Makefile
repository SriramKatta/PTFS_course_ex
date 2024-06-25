CXX:=icpx
CXXFLAGS1:=-O1 -no-vec -qopenmp
CXXFLAGS2:=-O3 -xAVX -qopenmp

CC:=icx
CFALGS:=-O3 -xHost

SRCSCXX:=./picalc/weirdpi.cpp
SRCSC:=./raytracer/raytrace_c.c ./raytracer/timing.c
TARGETS:=picalca picalcb raytrace_c raytrace_c_seq

all:folder $(TARGETS)

folder:
	rm -rf exe
	mkdir exe

picalca:
	$(CXX) $(CXXFLAGS1) $(extraflag) -o  ./exe/picalca $(SRCSCXX)
	@echo "building picalca exe file done"


picalcb:
	$(CXX) $(CXXFLAGS2) $(extraflag) -o ./exe/picalcb $(SRCSCXX)
	@echo "building picalcb exe file done"

raytrace_c:
	$(CC) $(CFALGS) -qopenmp -o ./exe/raytracer $(SRCSC)

raytrace_c_seq:
	$(CC) $(CFALGS) -o ./exe/raytracer_seq $(SRCSC)


cleanaux:
	@rm *.png -dat *.o* *.pnm

clean:
	@rm -rf exe