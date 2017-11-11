parserout :  ass3_15CS30003_parser.c lex.yy.c y.tab.c lexerout; gcc ass3_15CS30003_parser.c lex.yy.c y.tab.c -o parserout -lfl;
lexerout :  ass3_15CS30003_lexer.c lex.yy.c ; gcc ass3_15CS30003_lexer.c lex.yy.c -o lexerout -lfl;
lex.yy.c :   ass3_15CS30003.l y.tab.h; lex ass3_15CS30003.l;
y.tab.h :    ass3_15CS30003.y; yacc -vd ass3_15CS30003.y; 
clean:  ;rm parserout lexerout y.tab.h y.tab.c lex.yy.c y.output; 
