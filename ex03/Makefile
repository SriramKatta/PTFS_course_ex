CC:=icx
CFLAGS:=-O3 -xHost -fno-alias 

SRCS:=$(sort $(wildcard *.c))
HEADER:=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
TARGETS:=$(subst .c,,$(lastword $(SRCS)))

all:$(TARGETS)

$(TARGETS):$(OBJS)
	$(CC) $(var) $(wordlist 1, 2, $(CFLAGS)) -o $(word 1, $(TARGETS)) $(OBJS)
	@echo "building exe file done"

$(OBJS):$(SRCS) $(HEADER)
	$(CC) $(var) $(CFLAGS) -c $(lastword $(SRCS)) $(HEADER)
	$(CC) $(var) $(CFLAGS) -c $(firstword $(SRCS)) $(HEADER)
	@echo "building obj file done"

cleanaux:
	@rm *.png* *-dat *.o*

clean:
	@rm -rf *.o *.gch $(TARGETS)