CFLAGS=-c -Wall -O2
LIBS= -lsensehat -lpthread -lm

all: libsensehat.a sensedemo devdriv_2a

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
    
devdriv_2a: devdriv_2a.o
	$(CC) devdriv_2a.o $(LIBS) -o devdriv_2a
    
devdriv_2a.o: devdriv_2a.h devdriv_2a.c
	$(CC) $(CFLAGS) devdriv_2a.c
    
clean:
	rm *.o libsensehat.a ;\
    rm *.o sensedemo ;\
    rm *.o devdriv_2a

