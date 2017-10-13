a.out: lex.yy.o y.tab.o ass4_15CS30003_translator.o
	g++ lex.yy.o y.tab.o ass4_15CS30003_translator.o -lfl

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
	##### run command make test to generate quad outputs corresponding to test files given
	yacc -dtv ass4_15CS30003.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass4_15CS30003_translator.o y.output a.out

test:
	./a.out < ass4_15CS30003_test1.mm > ass4_15CS30003_quads1.out
	./a.out < ass4_15CS30003_test2.mm > ass4_15CS30003_quads2.out
	./a.out < ass4_15CS30003_test3.mm > ass4_15CS30003_quads3.out
	./a.out < ass4_15CS30003_test4.mm > ass4_15CS30003_quads4.out
	./a.out < ass4_15CS30003_test5.mm > ass4_15CS30003_quads5.out
	
