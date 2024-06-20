CXX:=g++
CXXFLAGS1:=-O1 -no-vec -qopenmp
CXXFLAGS2:=-O3 -xAVX -qopenmp


SRCS:=weirdpi.cpp
TARGETS:=picalca picalcb

all:folder $(TARGETS)

folder:
	rm -rf exe
	mkdir exe

picalca:
	$(CXX) $(CXXFLAGS1) -o picalca $(SRCS)
	@echo "building picalca exe file done"


picalcb:
	$(CXX) $(CXXFLAGS2) -o picalcb $(SRCS)
	@echo "building picalcb exe file done"


cleanaux:
	@rm *.png* *-dat *.o*  $(TARGETS)

clean:
	@rm -rf *.o *.gch