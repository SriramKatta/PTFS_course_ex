CC:=icx
CFLAGS:=-xHost -fno-alias


SRCS:=$(sort $(wildcard *.c))
HEADER:=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
TARGETS:=$(subst .c,,$(firstword $(SRCS)))

all:$(TARGETS)

$(TARGETS):$(OBJS)
	$(CC) $(firstword $(CFLAGS)) -qopenmp -o $(word 1, $(TARGETS))	$(word 1, $(OBJS)) $(lastword $(OBJS))
	@echo "building exe file done"

$(OBJS):$(SRCS) $(HEADER)
	$(CC)  $(wordlist 1, 2, $(CFLAGS)) -qopenmp -c $(word 1, $(SRCS)) $(lastword $(SRCS)) $(HEADER)
	@echo "building obj file done"

cleanaux:
	@rm *.png* *-dat *.o*  $(TARGETS)

clean:
	@rm -rf *.o *.gch