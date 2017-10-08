%{
#include "ass5_12CS10008_translator.h"

#include "y.tab.h"
#include <math.h>
void yyerror (char *);

%}

/* Regular Expression Definitions */

Digit					            [0-9]
identifier 				    [_a-zA-Z_][a-zA-Z0-9_]*
nonzero-digit		       [1-9]
E					            ([Ee][+-]?{Digit}+)
integer-constant		[1-9][0-9]*|0
floating-constant 		[-+]?[0-9]+[eE][-+]?[0-9]+|[-+]?[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?|[-+]?[0-9]+\.([eE][-+]?[0-9]+)?

character-constant		\'(\\.|[^\\'\n])*\'
Comments				"/*"([^*]|\*+[^*/])*\*+"/"|"//"(.)*
string-literal			\"(\\.|[^\\"\n])*\"
whitespace				[ \t\v\r\f\n]
%%


"break"         { return BREAK; }
"case"          { return CASE; }
"char"          { return CHAR; }
"const"         { return CONST; }
"continue"      { return CONTINUE; }
"default"       { return DEFAULT; }
"do"            { return DO; }
"double"        { return DOUBLE; }
"else"          { return ELSE; }

"float"         { return FLOAT; }
"for"           { return FOR; }
"goto"          { return GOTO; }
"if"            { return IF; }

"int"           { return INT; }
"long"          { return LONG; }

"return"        { return RETURN; }
"short"         { return SHORT; }
"signed"        { return SIGNED; }
"sizeof"        { return SIZEOF; }


"switch"        { return SWITCH; }


"unsigned"      { return UNSIGNED; }
"void"          { return VOID; }

"while"         { return WHILE; }
"_Bool"         { return BOOL; }

"Matrix"        { return MATRIX;    }

{string-literal} 			{ 	yylval.strval = yytext;
					return STRING_LITERAL; }
{identifier}			{	yylval.symp = table->lookup(yytext);
					return IDENTIFIER;  }
{integer-constant} 			{ 	yylval.intval = atoi(yytext);
					return INT_CONSTANT; }
{floating-constant} 			{ 	yylval.strval = yytext;
					                     return FLOAT_CONSTANT; }
{character-constant} 			{ return CHAR_CONSTANT; }

"["				{ return '['; }
"]"				{ return ']'; }
"("				{ return '('; }
")"				{ return ')'; }
"{"				{ return '{'; }
"}"				{ return '}'; }
"."				{ return '.'; }
"->"			{ return PTR_OP; }

"++"			{ return INC_OP; }
"--"			{ return DEC_OP; }
"&"				{ return '&'; }
"*"				{ return '*'; }
"+"				{ return '+'; }
"-"				{ return '-'; }
"~"				{ return '~'; }
"!"				{ return '!'; }

"/"				{ return '/'; }
"%"				{ return '%'; }
"<<"			{ return LEFT_OP; }
">>"			{ return RIGHT_OP; }
"<"				{ return '<'; }
">"				{ return '>'; }
"<="			{ return LE_OP; }
">="			{ return GE_OP; }
"=="			{ return EQ_OP; }
"!="			{ return NE_OP; }
"^"				{ return '^'; }
"|"				{ return '|'; }
"&&"			{ return AND_OP; }
"||"			{ return OR_OP; }

"?"				{ return '?'; }
":"				{ return ':'; }
";"				{ return ';'; }
"..."			{ return ELLIPSIS; }

"="				{ return '='; }
"*="			{ return MUL_ASSIGN; }
"/="			{ return DIV_ASSIGN; }
"%="			{ return MOD_ASSIGN; }
"+="			{ return ADD_ASSIGN; }
"-="			{ return SUB_ASSIGN; }
"<<="			{ return LEFT_ASSIGN; }
">>="			{ return RIGHT_ASSIGN; }
"&="			{ return AND_ASSIGN; }
"^="			{ return XOR_ASSIGN; }
"|="			{ return OR_ASSIGN; }
".'"            { return TRANSPOSE; }
","				{ return ','; }
"#"				{ return '#'; }

{whitespace}			{ /* whitespace separates tokens */ }
{Comments}        { ;}
%%
