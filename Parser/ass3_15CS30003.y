%{	
	#include "y.tab.h"
	#include <stdio.h>
	extern int yylex();
	extern FILE *yyin;
	extern char *yytext;
	void yyerror(const char *s);
%}
%start	start
%define parse.error verbose
%define parse.lac full

%token  UNSIGNED
%token  BREAK
%token  RETURN
%token  VOID
%token  CASE
%token  FLOAT
%token  SHORT
%token  CHAR
%token  FOR
%token  SIGNED
%token  WHILE
%token  GOTO
%token  BOOL
%token  CONTINUE
%token  IF
%token  DEFAULT
%token  DO
%token  INT
%token  SWITCH
%token  DOUBLE
%token  LONG
%token  ELSE
%token  MATRIX

%token  IDENTIFIER

%token  CONSTANT

%token  STRING_LITERAL

%token 	INCREMENT
%token	ARROW
%token	LESS_THAN_EQUAL
%token 	GREATER_THAN_EQUAL
%token	LEFT_SHIFT
%token 	RIGHT_SHIFT
%token	MULTIPLY
%token 	DIVIDE
%token 	REMAINDER
%token 	ADD
%token 	SUBTRACT
%token  LEFT_SHIFT_EQUAL
%token	DECREMENT
%token  EQUALITY
%token  RIGHT_SHIFT_EQUAL
%token	NOT_EQUAL_TO
%token  BITAND
%token 	POWER
%token	AND
%token 	OR
%token	OR_EQUAL
%token  TRANSPOSE
%token  ERROR

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start:	translation_unit
 
		;



primary_expression:	 IDENTIFIER
						{printf("primary_expresiion: IDENTIFIER\n");}
					| STRING_LITERAL
						{printf("primary_expresiion: STRING_LITERAL\n");}
					| CONSTANT
						{printf("primary_expresiion: CONSTANT\n");}
					
					| '(' expression ')'
						{printf("primary_expresiion: ( expression )\n");}
					;



postfix_expression:	 primary_expression
						{printf("postfix_expression:	 primary_expression\n");}
					| postfix_expression '[' expression ']'
						{printf("postfix_expression:	 postfix_expression [ expression ]\n");}
                    | postfix_expression '(' argument_expression_list ')'
						{printf("postfix_expression:	 postfix_expression ( argument_expression_list )\n");}
                    | postfix_expression '(' ')'
						{printf("postfix_expression:	 postfix_expression ( )\n");}
					| postfix_expression '.' IDENTIFIER
						{printf("postfix_expression:	 postfix_expression . IDENTIFIER\n");}
					| postfix_expression ARROW IDENTIFIER
						{printf("postfix_expression:	 postfix_expression -> IDENTIFIER\n");}
					| postfix_expression INCREMENT
						{printf("postfix_expression:	 postfix_expression ++\n");}
					| postfix_expression DECREMENT
						{printf("postfix_expression:	 postfix_expression --\n");}
                    | postfix_expression TRANSPOSE
						{printf("postfix_expression:	 postfix_expression    .'\n");}
					
					;


argument_expression_list:	assignment_expression
								{printf("argument_expression_list:	assignment_expression\n");}
							| argument_expression_list ',' assignment_expression
								{printf("argument_expression_list:	argument_expression_list , assignment_expression\n");}
							;


unary_expression:	postfix_expression
						{printf("unary_expression:	postfix_expression\n");}
					| INCREMENT unary_expression
						{printf("unary_expression:	++ unary_expression\n");}
					| DECREMENT unary_expression
						{printf("unary_expression:	-- unary_expression\n");}
					| unary_operator cast_expression
						{printf("unary_expression:	unary_operator cast_expression\n");}
	
					;



unary_operator: '&'
					{printf("unary_operator:	&\n");}
				| '*'
					{printf("unary_operator:	*\n");}
				| '+'
					{printf("unary_operator:	+\n");}
				| '-' 
					{printf("unary_operator:	-\n");}
				| '~' 
					{printf("unary_operator:	~\n");}
				| '!'
					{printf("unary_operator:	!\n");}
				;


cast_expression:	unary_expression
						{printf("cast_expression:	unary_expression\n");}

					;


multiplicative_expression:	cast_expression
								{printf("multiplicative_expression:	cast_expression\n");}
							| multiplicative_expression '*' cast_expression
								{printf("multiplicative_expression:	multiplicative_expression * cast_expression\n");}
							| multiplicative_expression '/' cast_expression
								{printf("multiplicative_expression:	multiplicative_expression / cast_expression\n");}
							| multiplicative_expression '%' cast_expression
								{printf("multiplicative_expression:	multiplicative_expression %% cast_expression\n");}
							;


additive_expression:	multiplicative_expression
							{printf("additive_expression:	multiplicative_expression\n");}
						| additive_expression '+' multiplicative_expression
							{printf("additive_expression:	additive_expression + multiplicative_expression\n");}
						| additive_expression '-' multiplicative_expression
							{printf("additive_expression:	additive_expression - multiplicative_expression\n");}
						;


shift_expression:	additive_expression
						{printf("shift_expression:	additive_expression\n");}
					| shift_expression LEFT_SHIFT additive_expression
						{printf("shift_expression:	shift_expression << additive_expression\n");}
					| shift_expression RIGHT_SHIFT additive_expression
						{printf("shift_expression:	shift_expression >> additive_expression\n");}
					;



relational_expression:	shift_expression
							{printf("relational_expression:	shift_expression\n");}
						| relational_expression '<' shift_expression
							{printf("relational_expression:	relational_expression < shift_expression\n");}
						| relational_expression '>' shift_expression
							{printf("relational_expression:	relational_expression > shift_expression\n");}
						| relational_expression LESS_THAN_EQUAL shift_expression
							{printf("relational_expression:	relational_expression <= shift_expression\n");}
						| relational_expression GREATER_THAN_EQUAL shift_expression
							{printf("relational_expression:	relational_expression >= shift_expression\n");}
						;


equality_expression:	relational_expression
							{printf("equality_expression:	relational_expression\n");}
						| equality_expression EQUALITY relational_expression
							{printf("equality_expression:	equality_expression == relational_expression\n");}
						| equality_expression NOT_EQUAL_TO relational_expression
							{printf("equality_expression:	equality_expression != relational_expression\n");}
						;


AND_expression:	equality_expression
					{printf("AND_expression:	equality_expression\n");}
				| AND_expression '&' equality_expression
					{printf("AND_expression:	AND_expression & equality_expression\n");}
				;


exclusive_OR_expression:	AND_expression
								{printf("exclusive_OR_expression:	AND_expression\n");}
							| exclusive_OR_expression '^' AND_expression
								{printf("exclusive_OR_expression:	exclusive_OR_expression ^ AND_expression\n");}
							;


inclusive_OR_expression:	exclusive_OR_expression
								{printf("inclusive_OR_expression:	exclusive_OR_expression\n");}
							| inclusive_OR_expression '|' exclusive_OR_expression
								{printf("inclusive_OR_expression:	inclusive_OR_expression | exclusive_OR_expression\n");}
							;
logical_AND_expression:	inclusive_OR_expression
								{printf("logical_AND_expression:	inclusive_OR_expression\n");}
						| logical_AND_expression AND inclusive_OR_expression
								{printf("logical_AND_expression:	logical_AND_expression && inclusive_OR_expression\n");}
						;
logical_OR_expression:	logical_AND_expression
								{printf("logical_OR_expression:	logical_AND_expression\n");}
						| logical_OR_expression OR logical_AND_expression
								{printf("logical_OR_expression:	logical_OR_expression || logical_AND_expression\n");}
						;
conditional_expression:	logical_OR_expression
								{printf("conditional_expression:	logical_OR_expression\n");}
						| logical_OR_expression '?' expression ':' conditional_expression
								{printf("conditional_expression:	logical_OR_expression ? expression : conditional_expression\n");}
						;
assignment_expression:	conditional_expression
							{printf("assignment_expression:	conditional_expression\n");}
						| unary_expression assignment_operator assignment_expression
							{printf("assignment_expression:	unary_expression assignment_operator assignment_expression\n");}
						;
assignment_operator: '='
						{printf("assignment_operator: =\n");}
					| MULTIPLY 
						{printf("assignment_operator: *=\n");}
					| DIVIDE 
						{printf("assignment_operator: /=\n");}
					| REMAINDER 
						{printf("assignment_operator: %%=\n");}
					| ADD
						{printf("assignment_operator: +=\n");} 
					| SUBTRACT 
						{printf("assignment_operator: -=\n");}
					| LEFT_SHIFT_EQUAL 
						{printf("assignment_operator: <<=\n");}
					| RIGHT_SHIFT_EQUAL 
						{printf("assignment_operator: >>=\n");}
					| BITAND
						{printf("assignment_operator: &=\n");} 
					| POWER
						{printf("assignment_operator: ^=\n");} 
					| OR_EQUAL
						{printf("assignment_operator: |=\n");}
					;
expression:	assignment_expression
				{printf("expression:	assignment_expression\n");}
			| expression ',' assignment_expression
				{printf("expression:	expression , assignment_expression\n");}
			;
constant_expression:	conditional_expression
							{printf("constant_expression:	conditional_expression\n");}
						;




declaration
	: declaration_specifiers ';'
		{printf("declaration: declaration_specifiers ;\n");}
	| declaration_specifiers init_declarator_list ';'
		{printf("declaration: declaration_specifiers init_declarator_list ;\n");}
	;


declaration_specifiers
	: 
	type_specifier
		{printf("declaration_specifiers: type_specifier\n");}
	| type_specifier declaration_specifiers
		{printf("declaration_specifiers: type_specifier declaration_specifiers\n");}

	;


init_declarator_list:	init_declarator
							{printf("init_declarator_list:	init_declarator\n");}
						| init_declarator_list ',' init_declarator
							{printf("init_declarator_list:	init_declarator_list , init_declarator\n");}
						;

init_declarator:	declarator
						{printf("init_declarator:	declarator\n");}
					| declarator '=' initializer
						{printf("init_declarator:	declarator = initializer\n");}
					;


type_specifier:	VOID
					{printf("type_specifier:	void\n");}
				| CHAR
					{printf("type_specifier:	char\n");}
				| SHORT
					{printf("type_specifier:	short\n");}
				| INT
					{printf("type_specifier:	int\n");}
				| LONG
					{printf("type_specifier:	long\n");}
				| FLOAT
					{printf("type_specifier:	float\n");}
				| DOUBLE
					{printf("type_specifier:	double\n");}
				| SIGNED
					{printf("type_specifier:	signed\n");}
				| UNSIGNED
					{printf("type_specifier:	unsigned\n");}
				| BOOL
					{printf("type_specifier:	Bool\n");}
				| MATRIX
					{printf("type_specifier:	Matrix\n");}

				;







iden_list_temp: identifier_list
					{printf("iden_list_opt: identifier_list\n");}
				|%empty
					{printf("iden_list_opt: epsilon\n");}
				;





assign_temp:	assignment_expression
					{printf("assignment_expression_opt:	assignment_expression\n");}
				|%empty
					{printf("assignment_expression_opt:	epsilon\n");}
            ;

declarator: pointer direct_declarator
		{printf("declarator: pointer direct_declarator\n");}
	| direct_declarator
		{printf("declarator: direct_declarator\n");}
	;

direct_declarator:	IDENTIFIER
						{printf("direct_declarator:	IDENTIFIER\n");}
					|'(' declarator ')'
						{printf("direct_declarator:	( declarator )\n");}
					|direct_declarator '[' assign_temp ']'
						{printf("direct_declarator:	direct_declarator [ assign_opt ]\n");}
					|direct_declarator '(' parameter_type_list ')'
						{printf("direct_declarator:	direct_declarator ( parameter_type_list )\n");}
					|direct_declarator '(' iden_list_temp ')'
						{printf("direct_declarator:	direct_declarator ( iden_list_opt )\n");}
					;

pointer:	'*' 
				{printf("pointer:	*\n");}
			|'*' pointer
				{printf("pointer:	* pointer\n");}
			;


parameter_type_list:	parameter_list
							{printf("parameter_type_list:	parameter_list\n");}
						
						;

parameter_list:	parameter_declaration
					{printf("parameter_list:	parameter_declaration\n");}
				|parameter_list ',' parameter_declaration
					{printf("parameter_list:	parameter_list , parameter_declaration\n");}
				;



parameter_declaration:	declaration_specifiers declarator
							{printf("parameter_declaration:	declaration_specifiers declarator\n");}
						|declaration_specifiers
							{printf("parameter_declaration:	declaration_specifiers\n");}
						;


identifier_list:	IDENTIFIER
						{printf("identifier_list:	IDENTIFIER\n");}	
					|identifier_list ',' IDENTIFIER
						{printf("identifier_list:	identifier_list , IDENTIFIER\n");}	
					;



initializer:	assignment_expression
					{printf("initializer:	assignment_expression\n");}	
				|'{' initializer_row_list '}'
					{printf("initializer:	{ initializer_row_list }\n");}	
                ;

initializer_row_list:	initializer_row
							{printf("initializer_row_list:	initializer_row\n");}	
						|initializer_row_list ';' initializer_row
							{printf("initializer_row_list:	initializer_row\n");}	
						;
initializer_row:designation_opt initializer
						{printf("initializer_row:	designation_opt initializer\n");}
				|initializer_row ',' designation_opt initializer 
						{printf("initializer_row:	initializer_row ',' designation_opt initializer\n");}
            ;

designation_opt:	designation
					{printf("designation_opt:	designation\n");}	
				|%empty
					{printf("designation_opt:	epsilon\n");}	
				;


designation:	designator_list '='
					{printf("designation:	designator_list =\n");}	
				;

designator_list:	designator
						{printf("designator_list:	designator \n");}
					|designator_list designator
						{printf("designator_list:	designator_list designator\n");}
					;
designator:	'[' constant_expression ']'
				{printf("designator:	[ constant_expression ] \n");}
			|'.' IDENTIFIER
				{printf("designator:	. IDENTIFIER \n");}
			;



statement:	labeled_statement
				{printf("statement:	labeled_statement \n");}
			|compound_statement
				{printf("statement:	compound_statement\n");}
			|expression_statement
				{printf("statement:	expression_statement \n");}
			|selection_statement
				{printf("statement:	selection_statement\n");}
			|iteration_statement
				{printf("statement:	iteration_statement\n");}
			|jump_statement
				{printf("statement:	jump_statement\n");}
			;

labeled_statement:	IDENTIFIER ':' statement
						{printf("labeled_statement:	IDENTIFIER : statement \n");}
					|CASE constant_expression ':' statement
						{printf("labeled_statement:	CASE constant_expression : statement \n");}
					|DEFAULT ':' statement
						{printf("labeled_statement:	DEFAULT : statement \n");}
					;



compound_statement:	'{' block_item_list '}'
						{printf("compound_statement:	{ block_item_list } \n");}
					|'{''}'
						{printf("compound_statement:	{  } \n");}
					;

block_item_list:	block_item
						{printf("block_item_list:	block_item \n");}
					|block_item_list block_item
						{printf("block_item_list:	block_item_list block_item \n");}
					;

block_item:	declaration
				{printf("block_item:	declaration  \n");}
			|statement
				{printf("block_item:	statement  \n");}
			;

expression_statement:	expression';' 
							{printf("expression_statement:	expression ;  \n");}
						|';'
							{printf("expression_statement:	; \n");}
						;



selection_statement:	IF '(' expression ')' statement %prec LOWER_THAN_ELSE
							{printf("selection_statement:	IF ( expression ) statement\n");}
						|IF '(' expression ')' statement ELSE statement
							{printf("selection_statement:	IF ( expression ) statement ELSE statement\n");}
						|SWITCH '(' expression ')' statement
							{printf("selection_statement:	SWITCH ( expression ) statement\n");}
						;

express_temp:	expression
					{printf("express_opt:	expression\n");}
				|%empty
					{printf("express_opt:	epsilon\n");}
				;

iteration_statement:	WHILE '(' expression ')' statement
							{printf("iteration_statement:	WHILE ( expression ) statement\n");}
						|DO statement WHILE '(' expression ')' ';'
							{printf("iteration_statement:	DO statement WHILE ( expression ) ;\n");}
						|FOR '(' express_temp ';' express_temp ';' express_temp ')' statement
							{printf("iteration_statement:	FOR ( expression_opt ; expression_opt ; expression_opt ) statement\n");}
						|FOR '(' declaration express_temp ';' express_temp ')' statement
							{printf("iteration_statement:	FOR ( declaration expression_opt ; expression_opt ) statement\n");}
						;

jump_statement:	GOTO IDENTIFIER ';'
					{printf("jump_statement:	GOTO IDENTIFIER ;\n");}
				|CONTINUE ';'
					{printf("jump_statement:	CONTINUE ;\n");}
				|BREAK ';'
					{printf("jump_statement:	BREAK ;\n");}
				|RETURN express_temp ';'
					{printf("jump_statement:	RETURN expression_opt ;\n");}
				;











translation_unit:	external_declaration
						{printf("translation_unit:	external_declaration\n");}
					|translation_unit external_declaration
						{printf("translation_unit:	translation_unit external_declaration\n");}
					;

external_declaration:	function_definition
							{printf("external_declaration:	function_definition\n");}
						|declaration
							{printf("external_declaration:	declaration\n");}
						;

decl_list_temp:	declaration_list
					{printf("decl_list_opt:	declaration_list\n");}
				|%empty
					{printf("decl_list_opt:	epsilon\n");}	
				;

function_definition:	declaration_specifiers declarator decl_list_temp compound_statement
							{printf("function_definition:	declaration_specifiers declarator decl_list_opt compound_statement\n");}
					;



declaration_list:	declaration
						{printf("declaration_list:	declaration\n");}
					|declaration_list declaration
						{printf("declaration_list:	declaration_list declaration\n");}
					;
%%



void yyerror(const char *s) {
printf("%s\n",s);
}



