%{
#include "ass4_15CS30003_translator.h"

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



"switch"        { return SWITCH; }


"unsigned"      { return UNSIGNED; }
"void"          { return VOID; }

"while"         { return WHILE; }
"_Bool"         { return BOOL; }

"Matrix"        { return MATRIX;    }

{string-literal} 			{ 	yylval.string_Value = yytext;
					return STRING_LITERAL; }
{identifier}			{	yylval.symp = table->lookup(yytext);
					return IDENTIFIER;  }
{integer-constant} 			{ 	yylval.integer_value = atoi(yytext);
					return INT_CONSTANT; }
{floating-constant} 			{ 	yylval.string_Value = yytext;
					                     return FLOAT_CONSTANT; }
{character-constant} 			{ 		yylval.charConst=yytext;
																return CHAR_CONSTANT; }

"["				{ return '['; }
"]"				{ return ']'; }
"("				{ return '('; }
")"				{ return ')'; }
"{"				{ return '{'; }
"}"				{ return '}'; }
"."				{ return '.'; }
"->"			{ return ARROW; }

"++"			{ return INCREMENT; }
"--"			{ return DECREMENT; }
"&"				{ return '&'; }
"*"				{ return '*'; }
"+"				{ return '+'; }
"-"				{ return '-'; }
"~"				{ return '~'; }
"!"				{ return '!'; }

"/"				{ return '/'; }
"%"				{ return '%'; }
"<<"			{ return LEFT_SHIFT; }
">>"			{ return RIGHT_SHIFT; }
"<"				{ return '<'; }
">"				{ return '>'; }
"<="			{ return LESS_THAN_EQUAL; }
">="			{ return GREATER_THAN_EQUAL; }
"=="			{ return EQUALITY; }
"!="			{ return NOT_EQUAL_TO; }
"^"				{ return '^'; }
"|"				{ return '|'; }
"&&"			{ return AND_AND; }
"||"			{ return OR_OR; }

"?"				{ return '?'; }
":"				{ return ':'; }
";"				{ return ';'; }
"..."			{ return ELLIPSIS; }

"="				{ return '='; }
"+="			{ return ADD_EQUAL;}
"*="			{ return MULT_EQUAL; }
"/="			{ return DIV_EQUAL; }
"%="			{ return MOD_EQUAL; }
"<<="			{ return LEFT_SHIFT_EQUAL; }
">>="			{ return RIGHT_SHIFT_EQUAL; }
"&="			{ return AND_EQUAL; }
"^="			{ return XOR_EQUAL; }
"|="			{ return OR_EQUAL; }
".'"            { return TRANSPOSE; }
","				{ return ','; }
"#"				{ return '#'; }

{whitespace}			{ /* whitespace separates tokens */ }
{Comments}        { ;}
%%
