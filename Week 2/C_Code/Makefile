CFLAGS=-c -Wall -O2
LIBS= -lsensehat -lpthread -lm

all: libsensehat.a sensedemo

libsensehat.a: sensehat.o
	ar -rc libsensehat.a sensehat.o ;\
	sudo cp libsensehat.a /usr/local/lib ;\
	sudo cp sensehat.h /usr/local/include

sensehat.o: sensehat.h sensehat.c
	$(CC) $(CFLAGS) sensehat.c

sensedemo: main.o
	$(CC) main.o $(LIBS) -o sensedemo

main.o: main.c
	$(CC) $(CFLAGS) main.c

clean:
	rm *.o libsensehat.a ;\
        rm *.o sensedemo

