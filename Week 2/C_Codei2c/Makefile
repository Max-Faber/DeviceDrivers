CFLAGS=-c -Wall -O2

main: main.o
	$(CC) -o main main.o

main.o: main.c main.h
	$(CC) $(CFLAGS) main.c

clean:
	rm *.o makemain
