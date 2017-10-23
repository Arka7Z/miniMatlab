asmGenerate: comp
	./comp 1 > ass4_15CS30003_quads1.out
	./comp 2 > ass4_15CS30003_quads2.out
	./comp 3 > ass4_15CS30003_quads3.out
	./comp 4 > ass4_15CS30003_quads4.out
	./comp 5 > ass4_15CS30003_quads5.out

comp: lex.yy.o y.tab.o ass4_15CS30003_translator.o ass4_15CS30003_target_translator.o
	g++ lex.yy.o y.tab.o ass4_15CS30003_translator.o \
	ass4_15CS30003_target_translator.o -lfl -o comp

ass4_15CS30003_target_translator.o: ass4_15CS30003_target_translator.cxx
	g++ -c ass4_15CS30003_target_translator.cxx

ass4_15CS30003_translator.o: ass4_15CS30003_translator.cxx ass4_15CS30003_translator.h
	g++ -c ass4_15CS30003_translator.h
	g++ -c ass4_15CS30003_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass4_15CS30003.l y.tab.h ass4_15CS30003_translator.h
	flex ass4_15CS30003.l

y.tab.c: ass4_15CS30003.y
	yacc -dtv ass4_15CS30003.y -W

y.tab.h: ass4_15CS30003.y
	yacc -dtv ass4_15CS30003.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass4_15CS30003_translator.o test1 test2 test3 test4 test5 y.output comp ass4_15CS30003_target_translator.o libass4_15CS30003.a ass4_15CS30003_1.o ass4_15CS30003.o ass4_15CS30003_2.o ass4_15CS30003_3.o ass4_15CS30003_4.o ass4_15CS30003_5.o

clean1:
	rm test1 ass4_15CS30003_1.o libass4_15CS30003.a ass4_15CS30003.o

#Test files
test1: ass4_15CS30003_1.o libass4_15CS30003.a
	gcc ass4_15CS30003_1.o -o test1 -L. -lass4_15CS30003
ass4_15CS30003_1.o: myl.h
	gcc -c ass4_15CS30003_1.s

test2: ass4_15CS30003_2.o libass4_15CS30003.a
	gcc ass4_15CS30003_2.o -o test2 -L. -lass4_15CS30003
ass4_15CS30003_2.o: myl.h
	gcc -Wall -c ass4_15CS30003_2.s

test3: ass4_15CS30003_3.o libass4_15CS30003.a
	gcc ass4_15CS30003_3.o -o test3 -L. -lass4_15CS30003
ass4_15CS30003_3.o: myl.h
	gcc -Wall -c ass4_15CS30003_3.s

test4: ass4_15CS30003_4.o libass4_15CS30003.a
	gcc ass4_15CS30003_4.o -o test4 -L. -lass4_15CS30003
ass4_15CS30003_4.o: myl.h
	gcc -Wall -c ass4_15CS30003_4.s

test5: ass4_15CS30003_5.o libass4_15CS30003.a
	gcc ass4_15CS30003_5.o -o test5 -L. -lass4_15CS30003
ass4_15CS30003_5.o: myl.h
	gcc -Wall -c ass4_15CS30003_5.s


libass4_15CS30003.a: ass4_15CS30003.o
	ar -rcs libass4_15CS30003.a ass4_15CS30003.o

ass4_15CS30003.o: ass4_15CS30003.c myl.h
	gcc -Wall -c ass4_15CS30003.c
