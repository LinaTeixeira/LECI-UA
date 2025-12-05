CFLAGS += -g -Wall -Wextra
TARGETS = 01.example

all: $(TARGETS)

IntegersQueue.o:	IntegersQueue.c IntegersQueue.h
IntegersStack.o:	IntegersStack.c IntegersStack.h

01_example.o: 01_example.c IntegersQueue.h IntegersStack.h

01_example: 01.o IntegersQueue.o IntegersStack.Options

clean:
	rm -f *.o
	rm -f $(TARGETS)