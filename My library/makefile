a.out: main.o libass2_15CS30003.a
	c++ main.o -L. -lass2_15CS30003

main.o: main.c myl.h
	c++  -c main.c
 
libass2_15CS30003.a: ass2_15CS30003.o
	ar -rcs libass2_15CS30003.a ass2_15CS30003.o

ass2_15CS30003.o: ass2_15CS30003.c myl.h
	c++  -c ass2_15CS30003.c

clean:2
	rm a.out main.o libass2_15CS30003.a ass2_15CS30003.o
