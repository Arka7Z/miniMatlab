%{
#include "y.tab.h"
%}

/*Regular expressions and definitions*/
identifier 				[_a-zA-Z_][a-zA-Z0-9_]*
integer-constant		[1-9][0-9]*|0
floating-constant 		[-+]?[0-9]+[eE][-+]?[0-9]+|[-+]?[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?|[-+]?[0-9]+\.([eE][-+]?[0-9]+)?

character-constant		\'(\\.|[^\\'\n])*\'
Comments				"/*"([^*]|\*+[^*/])*\*+"/"|"//"(.)*
string-literal			\"(\\.|[^\\"\n])*\"
whitespace				[ \t\v\r\f\n]

%%

"unsigned"              { return UNSIGNED;  }
"break"                 { return BREAK; }
"return"                { return RETURN; }
"void"                  { return VOID;  }
"case"                  { return CASE;  }
"float"                 { return FLOAT; }
"short"                 { return SHORT; }
"char"                  { return CHAR;  }
"for"                   { return FOR;   }
"signed"                { return SIGNED;}
"while"                 { return WHILE; }
"goto"                  { return GOTO;  }
"Bool"                  { return BOOL;  }
"continue"              { return CONTINUE; }
"if"                    { return IF;    }
"default"               { return DEFAULT;  }
"do"                    { return DO;    }
"int"                   { return INT;   }
"switch"                { return SWITCH; }
"double"                { return DOUBLE;}
"long"                  { return LONG;  }
"else"                  { return ELSE;  }
"Matrix"                { return MATRIX;}

{identifier}		    { return IDENTIFIER;}

{integer-constant} 	    { return CONSTANT;}
{floating-constant}	    { return CONSTANT;}
{character-constant}    { return CONSTANT;}


{string-literal} 	    { return STRING_LITERAL;}

"["					    { return '[';}
"++"				    { return INCREMENT;}
"/"					    { return '/';}
"?"					    { return '?';}
":"					    { return ':';}
"="					    { return '=';}
","					    { return ',';}
"]"					    { return ']';}
"("					    { return '(';}
"{"					    { return '{';}
"}"					    { return '}';}
"."					    { return '.';}
"->"				    { return ARROW;}
"*"					    { return '*';}
"+"					    { return '+';}
"-"					    { return '-';}
"~"					    { return '~';}
"!"					    { return '!';}
"%"					    { return '%';}
"<<"				    { return LEFT_SHIFT;}
">>"				    { return RIGHT_SHIFT;}
"<"					    { return '<';}
">"					    { return '>';}
"<="				    { return LESS_THAN_EQUAL;}
">="				    { return GREATER_THAN_EQUAL;}
";"					    { return ';';}
"*="				    { return MULTIPLY;}
"/="				    { return DIVIDE;}
"%="				    { return REMAINDER;}
"+="				    { return ADD;}
"-="				    { return SUBTRACT;}
"<<="				    { return LEFT_SHIFT_EQUAL;}
"#"					    { return '#';}
"--"				    { return DECREMENT;}
")"					    { return ')';}
"&"					    { return '&';}
"=="				    { return EQUALITY;}
">>="				    { return RIGHT_SHIFT_EQUAL;}
"!="				    { return NOT_EQUAL_TO;}
"&="				    { return BITAND;}
"^="				    {return POWER;}
"^"					    { return '^';}
"|"					    { return '|';}
"&&"				    { return AND;}
"||"				    { return OR;}
"|="				    { return OR_EQUAL;}
".'"                    { return TRANSPOSE; }

{Comments}			    { ; }
{whitespace}				    { ; }
.					    { return ERROR; }
%%




