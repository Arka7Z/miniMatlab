#asmGenerate: comp
#	./comp 1 > ass5_15CS30003_quads1.out
#	./comp 2 > ass5_15CS30003_quads2.out
#	./comp 3 > ass5_15CS30003_quads3.out
#	./comp 4 > ass5_15CS30003_quads4.out
#	./comp 5 > ass5_15CS30003_quads5.out

comp: lex.yy.o y.tab.o ass5_15CS30003_translator.o ass5_15CS30003_target_translator.o libprintlib.a
	g++ lex.yy.o y.tab.o ass5_15CS30003_translator.o ass5_15CS30003_target_translator.o -lfl -o comp

ass5_15CS30003_target_translator.o: ass5_15CS30003_target_translator.cxx
	g++ -c ass5_15CS30003_target_translator.cxx

ass5_15CS30003_translator.o: ass5_15CS30003_translator.cxx ass5_15CS30003_translator.h
	g++ -c ass5_15CS30003_translator.h
	g++ -c ass5_15CS30003_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_15CS30003.l y.tab.h ass5_15CS30003_translator.h
	flex ass5_15CS30003.l

y.tab.c: ass5_15CS30003.y
	yacc -dtv ass5_15CS30003.y -W

y.tab.h: ass5_15CS30003.y
	yacc -dtv ass5_15CS30003.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_15CS30003_translator.o test1 test2 test3 test4 test5 y.output comp ass5_15CS30003_target_translator.o libprintlib.a ass5_15CS30003_1.o printlib.o ass5_15CS30003_2.o ass5_15CS30003_3.o ass5_15CS30003_4.o ass5_15CS30003_5.o

clean_exec:
	rm test1 ass5_15CS30003_1.o libprintlib.a printlib.o test2 ass5_15CS30003_2.o test3 ass5_15CS30003_3.o test4 ass5_15CS30003_4.o test5 ass5_15CS30003_5.o test6 ass5_15CS30003_6.o

#Test files
test1: ass5_15CS30003_1.o libprintlib.a
	gcc ass5_15CS30003_1.o -o test1 -L. -lprintlib
ass5_15CS30003_1.o: myl.h ass5_15CS30003_1.s
	gcc -c ass5_15CS30003_1.s

test2: ass5_15CS30003_2.o libprintlib.a
	gcc ass5_15CS30003_2.o -o test2 -L. -lprintlib
ass5_15CS30003_2.o: myl.h ass5_15CS30003_2.s
	gcc -Wall -c ass5_15CS30003_2.s

test3: ass5_15CS30003_3.o libprintlib.a
	gcc ass5_15CS30003_3.o -o test3 -L. -lprintlib
ass5_15CS30003_3.o: myl.h ass5_15CS30003_3.s
	gcc -Wall -c ass5_15CS30003_3.s

test4: ass5_15CS30003_4.o libprintlib.a
	gcc ass5_15CS30003_4.o -o test4 -L. -lprintlib
ass5_15CS30003_4.o: myl.h ass5_15CS30003_4.s
	gcc -Wall -c ass5_15CS30003_4.s

test5: ass5_15CS30003_5.o libprintlib.a
	gcc ass5_15CS30003_5.o -o test5 -L. -lprintlib
ass5_15CS30003_5.o: myl.h ass5_15CS30003_5.s
	gcc -Wall -c ass5_15CS30003_5.s

test6: ass5_15CS30003_6.o libprintlib.a
	gcc ass5_15CS30003_6.o -o test6 -L. -lprintlib
ass5_15CS30003_6.o: myl.h ass5_15CS30003_6.s
	gcc -Wall -c ass5_15CS30003_6.s

ass5_15CS30003_1.s: comp ass5_15CS30003_test1.c
	./comp 1
ass5_15CS30003_2.s: comp ass5_15CS30003_test2.c
	./comp 2
ass5_15CS30003_3.s: comp ass5_15CS30003_test3.c
	./comp 3
ass5_15CS30003_4.s: comp ass5_15CS30003_test4.c
	./comp 4
ass5_15CS30003_5.s: comp ass5_15CS30003_test5.c
	./comp 5
ass5_15CS30003_6.s: comp ass5_15CS30003_test6.c
	./comp 6

libprintlib.a: printlib.o
	ar -rcs libprintlib.a printlib.o

printlib.o: ass2_15CS30003.c myl.h
	gcc -Wall -c ass2_15CS30003.c -o printlib.o
