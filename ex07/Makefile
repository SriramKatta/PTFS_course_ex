CXX:=icpx
CXXFLAGS1:=-O1 -no-vec -qopenmp
CXXFLAGS2:=-O3 -xAVX -qopenmp

CC:=icx
CFALGS:=-O3 -xHost

SRCSCXX:=./picalc/weirdpi.cpp
SRCSC:=./raytracer/raytrace_c.c ./raytracer/timing.c
TARGETS:=picalca picalcb raytrace_c raytrace_c_seq

all: picalc raytracer

picalc: picalca picalcb

raytracer: raytracer_c_par raytracer_c_seq

picalca:
	@$(CXX) $(CXXFLAGS1) $(extraflag) -o  ./exe/picalca $(SRCSCXX)
	@echo "building picalca exe file done"

picalcb:
	@$(CXX) $(CXXFLAGS2) $(extraflag) -o ./exe/picalcb $(SRCSCXX)
	@echo "building picalcb exe file done"

raytracer_c_par:
	@$(CC) $(CFALGS) -qopenmp -o ./exe/raytracer_par $(SRCSC)
	@echo "building raytrace_c_par exe file done"

raytracer_c_seq:
	@$(CC) $(CFALGS) -o ./exe/raytracer_seq $(SRCSC)
	@echo "building raytrace_c_seq exe file done"


cleanaux: clean
	@rm -rf *.png *data *.o* *.pnm slurmoutfile

clean:
	@rm -rf exe simdata