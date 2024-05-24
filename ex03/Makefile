CC:=icx
CFLAGS:=-O3 -xHost -fno-alias 

SRCS:=$(sort $(wildcard *.c))
HEADER:=$(wildcard *.h)
OBJS=$(SRCS:.c=.o)
TARGETS:=$(subst .c,,$(wordlist 1, 2, $(SRCS)))

all:$(TARGETS)

$(TARGETS):$(OBJS)
	$(CC) $(var) $(wordlist 1, 2, $(CFLAGS)) \
	-o $(word 1, $(TARGETS)) \
	$(word 1, $(OBJS)) $(lastword $(OBJS))
	$(CC) $(var) $(wordlist 1, 2, $(CFLAGS)) \
	-o $(word 2, $(TARGETS)) \
	$(word 2, $(OBJS)) $(lastword $(OBJS))
	@echo "building exe file done"

$(OBJS):$(SRCS) $(HEADER)
	$(CC) $(var) $(CFLAGS) \
	-c $(word 1, $(SRCS)) \
	$(lastword $(SRCS)) $(HEADER)
	$(CC) $(var) $(CFLAGS) \
	-c $(word 2, $(SRCS)) \
	$(lastword $(SRCS)) $(HEADER)
	@echo "building obj file done"

cleanaux:
	@rm *.png* *-dat *.o*

clean:
	@rm -rf *.o *.gch $(TARGETS)