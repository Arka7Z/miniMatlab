 %{

	#include <string.h>
	#include <stdio.h>
	#include "ass5_12CS10008_translator.h"
	extern	int yylex();
	void yyerror(const char *s);
	extern type_e TYPE;
	extern int gDebug;
    extern bool transRUN;
    extern bool rowison;

%}


%union {
	int intval;
	int instr;
	char* strval;
	float floatval;
	sym* symp;
	expr* exp;
	list<int>* nl;
	symtype* st;
	statement* stat;
	unary* A;
	char uop;	//unary operator
}


%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID MATRIX
%token BOOL

%token BREAK CASE CONTINUE DEFAULT DO IF ELSE FOR GOTO WHILE SWITCH SIZEOF
%token RETURN

%token ELLIPSIS RIGHT_ASSIGN LEFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN
%token DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN RIGHT_OP LEFT_OP
%token INC_OP DEC_OP PTR_OP AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP TRANSPOSE

%token <strval> STRING_LITERAL
%token <symp>IDENTIFIER  PUNCTUATORS COMMENT
%token <intval>INT_CONSTANT

%token <strval> FLOAT_CONSTANT
	ENU_CONSTANT
%token <char>CHAR_CONSTANT

%start translation_unit

// Expressions
%type <A> postfix_expression
	unary_expression
	cast_expression
%type <exp>
	expression
	primary_expression
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	and_expression
	exclusive_or_expression
	inclusive_or_expression
	logical_and_expression
	logical_or_expression
	conditional_expression
	assignment_expression
	expression_statement
    empty_token


%type <uop> unary_operator
%type <symp> constant initializer initializer_row_list designation
%type <symp> initializer_row

%type <instr> M
%type <exp> N
%type <st> pointer
%type <symp> direct_declarator init_declarator declarator
%type <intval> argument_expression_list

%type <stat>  statement
	labeled_statement
	compound_statement

	selection_statement
	iteration_statement
	jump_statement
	block_item
	block_item_list

%%
primary_expression
	: IDENTIFIER {
		$$ = new expr();
		$$->symp = $1;
		$$->isbool = false;
	}
	| constant {
		$$ = new expr();
		$$->symp = $1;
	}
	| STRING_LITERAL {
		$$ = new expr();
		$$->symp = gentemp(PTR, $1);
		$$->symp->initialize($1);
		$$->symp->type->ptr = new symtype(_CHAR);
	}
	| '(' expression ')' {
		$$ = $2;
	}
	;

constant
	: INT_CONSTANT {
		$$ = gentemp(_INT, NumberToString($1));
		emit(EQUAL, $$->name, $1);
	}
	| FLOAT_CONSTANT {
        if (rowison==false)
        {
		$$ = gentemp(_DOUBLE, *new string ($1));
		emit(EQUAL, $$->name, *new string($1));
        }
        else
         {
            $$=new sym(*new string($1),_DOUBLE);
            $$->init=*new string($1);
           }
	}

	| CHAR_CONSTANT{
		$$ = gentemp(_CHAR);
		emit(EQUAL, $$->name, "a");
	}
	;

postfix_expression
	: primary_expression  {
		$$ = new unary ();
		$$->symp = $1->symp;
		$$->loc = $$->symp;
		$$->type = $1->symp->type;
        $$->cat=$$->type->cat;
	}
	| postfix_expression '[' expression ']''['expression']' {
		$$ = new unary();

		$$->symp = $1->symp;			// copy the base
		$$->type = $1->type->ptr;		// type = type of element
		$$->loc = new sym("",_INT);		// store computed address

		if ($1->cat==_MATRIX) {
			sym* t = gentemp(_INT);
 			emit(MULT, t->name, $3->symp->name, tostr(4));
            sym* t1=gentemp(_INT);
            emit(ARRR, t1->name, $1->symp->name,tostr(4));
            sym* t2=gentemp(_INT);
            emit(SUB,t2->name,t->name,tostr(4));
            sym* t3=gentemp(_INT);
            emit(MULT, t3->name, t2->name, t1->name);     //t5=t4*T3
            sym* t4=gentemp(_INT);
            emit(MULT, t4->name, $6->symp->name, tostr(4));  //t6=i*4
            sym* t5=gentemp(_INT);
            emit(ADD, t5->name,t3->name, t4->name);
            sym* t6=gentemp(_INT);
            emit(ADD, t6->name,t5->name,tostr(8));          //t8=t7+t8
            $$->loc->name=t6->name;

		}
 		else {
	 		emit(MULT, $$->loc->name, $3->symp->name, NumberToString(sizeoftype($$->type)));
 		}

		$$->cat = _MATRIX;
        $$->symp->type->cat=_MATRIX;

	}
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')' {
		$$ = new unary();
		$$->symp = gentemp($1->type->cat);
		emit(CALL, $$->symp->name, $1->symp->name, tostr($3));
	}
	| postfix_expression '.' IDENTIFIER /* Ignored */
	| postfix_expression PTR_OP IDENTIFIER  /* Ignored */
	| postfix_expression INC_OP {
		$$ = new unary();

		// copy $1 to $$

         if ($1->symp->type->cat==_MATRIX)
        {
            sym* t1=gentemp(_DOUBLE);
            sym* t2=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$1->symp->name,$1->loc->name);
            emit(ARRR,t2->name,$1->symp->name,$1->loc->name);
            emit(ADD,t1->name,t1->name, "1");
            emit(ARRL,$1->symp->name,$1->loc->name,t1->name);
            $$->symp=t2;
        }
        else
        {
		    $$->symp = gentemp($1->symp->type->cat);
		    emit (EQUAL, $$->symp->name, $1->symp->name);

		    // Increment $1
		    emit (ADD, $1->symp->name, $1->symp->name, "1");
        }
	}
	| postfix_expression DEC_OP {
		$$ = new unary();
         if ($1->symp->type->cat==_MATRIX)
        {
            sym* t1=gentemp(_DOUBLE);
            sym* t2=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$1->symp->name,$1->loc->name);
            emit(ARRR,t2->name,$1->symp->name,$1->loc->name);
            emit(SUB,t1->name,t1->name, "1");
            emit(ARRL,$1->symp->name,$1->loc->name,t1->name);
            $$->symp=t2;
        }
        else
        {
		// copy $1 to $$
		$$->symp = gentemp($1->symp->type->cat);
		emit (EQUAL, $$->symp->name, $1->symp->name);

		// Decrement $1
		emit (SUB, $1->symp->name, $1->symp->name, "1");
        }
	}

    | postfix_expression TRANSPOSE{
            transRUN=true;

            sym* t=gentemp($1->type,"transpose");
            emit(TRANSOP,t->name,$1->symp->name);
            $$->symp=t;
        }
	;

argument_expression_list
	: assignment_expression {
		emit (PARAM, $1->symp->name);
		$$ = 1;
	}
	| argument_expression_list ',' assignment_expression {
		emit (PARAM, $3->symp->name);
		$$ = $1+1;
	}
	;

unary_expression
	: postfix_expression
    {
		$$ = $1;
	}
	| INC_OP unary_expression
    {
        if ($2->symp->type->cat==_MATRIX)
        {
            sym* t1=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$2->symp->name,$2->loc->name);
            emit(ADD,t1->name,t1->name, "1");
            emit(ARRL,$2->symp->name,$2->loc->name,t1->name);

        }
        else
        {
		    emit (ADD, $2->symp->name, $2->symp->name, "1");
        }
		$$ = $2;
	}
	| DEC_OP unary_expression {

         if ($2->symp->type->cat==_MATRIX)
        {
            sym* t1=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$2->symp->name,$2->loc->name);
            emit(SUB,t1->name,t1->name, "1");
            emit(ARRL,$2->symp->name,$2->loc->name,t1->name);
        }
        else{
		// Decrement $1
		emit (SUB, $2->symp->name, $2->symp->name, "1");
        }

		// Use the same value
		$$ = $2;
	}
	| unary_operator cast_expression {
		$$ = new unary();
		switch ($1) {
			case '&':
				        $$->symp = gentemp(PTR);
				        $$->symp->type->ptr = $2->symp->type;
                        if ($2->symp->type->cat==_MATRIX)
                            {
                                $$->symp->type->ptr=new symtype(_DOUBLE);
                                string array_name=$2->symp->name;
                                string location=$2->loc->name;
                                emit(EQUAL, $$->symp->name,"&"+array_name+"["+location+"]" );
                            }
                        else
				            emit (ADDRESS, $$->symp->name, $2->symp->name);
				        break;
			case '*':
                        $$->cat = PTR;
                        $$->loc = gentemp ($2->symp->type->ptr);
				        emit (PTRR, $$->loc->name, $2->symp->name);
				        $$->symp = $2->symp;
				        break;
			case '+':
				        $$ = $2;
				        break;
			case '-':
				        $$->symp = gentemp($2->symp->type->cat);
				        emit (UMINUS, $$->symp->name, $2->symp->name);
				        break;
			case '~':
				        $$->symp = gentemp($2->symp->type->cat);
				        emit (BNOT, $$->symp->name, $2->symp->name);
				        break;
			case '!':
				        $$->symp = gentemp($2->symp->type->cat);
				        emit (LNOT, $$->symp->name, $2->symp->name);
				        break;
			default:
				        break;
		}
	}
;

unary_operator
	: '&' {
		$$ = '&';
	}
	| '*' {
		$$ = '*';
	}
	| '+' {
		$$ = '+';
	}
	| '-' {
		$$ = '-';
	}
	| '~' {
		$$ = '-';
	}
	| '!' {
		$$ = '!';
	}
	;

cast_expression
	: unary_expression  {
		$$ = $1;
	}

	;

multiplicative_expression
	: cast_expression
        {
		$$ = new expr();
		if ($1->cat==_MATRIX) { // Array

            if (transRUN==false)
               {
                symtype *t=new symtype($1->cat,NULL,0);
                t->row=$1->symp->type->row;
                t->column=$1->symp->type->column;
                $$->symp = gentemp(t,"Mat_temp");
			  emit(ARRR, $$->symp->name, $1->symp->name, $1->loc->name);
                }
            else
                {
                    //$$->symp = gentemp($1->type,"transpose");
                    $$->symp = $1->symp;
                }
		}
		else if ($1->cat==PTR) { // Pointer
			$$->symp = $1->loc;
		}
		else { // otherwise
			$$->symp = $1->symp;
		}
	}
	| multiplicative_expression '*' cast_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			$$ = new expr();
			$$->symp = gentemp($1->symp->type->cat);
			emit (MULT, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	| multiplicative_expression '/' cast_expression{
		if (typecheck ($1->symp, $3->symp) ) {
			$$ = new expr();
			$$->symp = gentemp($1->symp->type->cat);
			emit (DIVIDE, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	| multiplicative_expression '%' cast_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			$$ = new expr();
			$$->symp = gentemp($1->symp->type->cat);
			emit (MODULUS, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

additive_expression
	: multiplicative_expression {$$ = $1;}
	| additive_expression '+' multiplicative_expression {
		if (typecheck($1->symp, $3->symp)) {
			$$ = new expr();
			$$->symp = gentemp($1->symp->type->cat);
			emit (ADD, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	| additive_expression '-' multiplicative_expression {
		if (typecheck($1->symp, $3->symp)) {
			$$ = new expr();
			$$->symp = gentemp($1->symp->type->cat);
			emit (SUB, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

shift_expression
	: additive_expression {$$ = $1;}
	| shift_expression LEFT_OP additive_expression {
		if ($3->symp->type->cat == _INT) {
			$$ = new expr();
			$$->symp = gentemp (_INT);
			emit (LEFTSHIFT, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	| shift_expression RIGHT_OP additive_expression {
		if ($3->symp->type->cat == _INT) {
			$$ = new expr();
			$$->symp = gentemp (_INT);
			emit (RIGHTSHIFT, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

relational_expression
	: shift_expression { $$ = $1;}
	| relational_expression '<' shift_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// New bool
			$$ = new expr();
			$$->isbool = true;

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit(LT, "", $1->symp->name, $3->symp->name);
			emit (GOTOOP, "");
		}
		else cout << "Type Error"<< endl;
	}
	| relational_expression '>' shift_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// New bool
			$$ = new expr();
			$$->isbool = true;

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit(GreaterThan, "", $1->symp->name, $3->symp->name);
			emit (GOTOOP, "");
		}
		else cout << "Type Error"<< endl;
	}
	| relational_expression LE_OP shift_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// New bool
			$$ = new expr();
			$$->isbool = true;

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit(LE, "", $1->symp->name, $3->symp->name);
			emit (GOTOOP, "");
		}
		else cout << "Type Error"<< endl;
	}
	| relational_expression GE_OP shift_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// New bool
			$$ = new expr();
			$$->isbool = true;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit(GE, "", $1->symp->name, $3->symp->name);
			emit (GOTOOP, "");
		}
		else cout << "Type Error"<< endl;
	}
	;

equality_expression
	: relational_expression {$$ = $1;}
	| equality_expression EQ_OP relational_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// If any is bool get its value
			convertfrombool ($1);
			convertfrombool ($3);

			$$ = new expr();
			$$->isbool = true;

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit (EQOP, "", $1->symp->name, $3->symp->name);
			emit (GOTOOP, "");
		}
		else cout << "Type Error"<< endl;
	}
	| equality_expression NE_OP relational_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// If any is bool get its value
			convertfrombool ($1);
			convertfrombool ($3);

			$$ = new expr();
			$$->isbool = true;

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit (NEOP, $$->symp->name, $1->symp->name, $3->symp->name);
			emit (GOTOOP, "");
		}
		else cout << "Type Error"<< endl;
	}
	;

and_expression
	: equality_expression {$$ = $1;}
	| and_expression '&' equality_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			$$ = new expr();
			$$->isbool = false;

			$$->symp = gentemp (_INT);
			emit (BAND, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

exclusive_or_expression
	: and_expression {$$ = $1;}
	| exclusive_or_expression '^' and_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// If any is bool get its value
			convertfrombool ($1);
			convertfrombool ($3);

			$$ = new expr();
			$$->isbool = false;

			$$->symp = gentemp (_INT);
			emit (XOR, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

inclusive_or_expression
	: exclusive_or_expression {$$ = $1;}
	| inclusive_or_expression '|' exclusive_or_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// If any is bool get its value
			convertfrombool ($1);
			convertfrombool ($3);

			$$ = new expr();
			$$->isbool = false;

			$$->symp = gentemp (_INT);
			emit (INOR, $$->symp->name, $1->symp->name, $3->symp->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

logical_and_expression
	: inclusive_or_expression {$$ = $1;}
	| logical_and_expression N AND_OP M inclusive_or_expression {
		convert2bool($5);

		// N to convert $1 to bool
		backpatch($2->nextlist, nextinstr());
		convert2bool($1);

		$$ = new expr();
		$$->isbool = true;

		backpatch($1->truelist, $4);
		$$->truelist = $5->truelist;
		$$->falselist = merge ($1->falselist, $5->falselist);
	}
	;

logical_or_expression
	: logical_and_expression {$$ = $1;}
	| logical_or_expression N OR_OP M logical_and_expression {
		convert2bool($5);

		// N to convert $1 to bool
		backpatch($2->nextlist, nextinstr());
		convert2bool($1);

		$$ = new expr();
		$$->isbool = true;

		backpatch ($$->falselist, $4);
		$$->truelist = merge ($1->truelist, $5->truelist);
		$$->falselist = $5->falselist;
	}
	;

M 	: %empty{	// To store the address of the next instruction for further use.
		$$ = nextinstr();
	};

N 	: %empty { 	// Non terminal to prevent fallthrough by emitting a goto

		$$  = new expr();
		$$->nextlist = makelist(nextinstr());
		emit (GOTOOP,"");

	}

conditional_expression
	: logical_or_expression {$$ = $1;}
	| logical_or_expression N '?' M expression N ':' M conditional_expression {
//		convert2bool($5);
		$$->symp = gentemp();
		$$->symp->update($5->symp->type);
		emit(EQUAL, $$->symp->name, $9->symp->name);
		list<int> l = makelist(nextinstr());
		emit (GOTOOP, "");

		backpatch($6->nextlist, nextinstr());
		emit(EQUAL, $$->symp->name, $5->symp->name);
		list<int> m = makelist(nextinstr());
		l = merge (l, m);
		emit (GOTOOP, "");

		backpatch($2->nextlist, nextinstr());
		convert2bool ($1);
		backpatch ($1->truelist, $4);
		backpatch ($1->falselist, $8);
		backpatch (l, nextinstr());
	}
	;

assignment_expression
	: conditional_expression {
		$$ = $1;
	}
	| unary_expression assignment_operator assignment_expression {///////////////////
		switch ($1->cat) {
			case _MATRIX:
				$3->symp = conv($3->symp, $1->type->cat);
                if (transRUN==false)
				        emit(ARRL, $1->symp->name, $1->loc->name, $3->symp->name);
                else
                    {
                        emit(EQUAL, $1->symp->name,$3->symp->name);
                        transRUN=false;
                    }
				break;
			case PTR:
				emit(PTRL, $1->symp->name, $3->symp->name);
				break;
			default:
				$3->symp = conv($3->symp, $1->symp->type->cat);
				emit(EQUAL, $1->symp->name, $3->symp->name);
				break;
		}
		$$ = $3;
	}
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression {
		$$ = $1;
	}
	| expression ',' assignment_expression
	//{printf("expression\n");}
	;

constant_expression
	: conditional_expression
	//{printf("constant_expression\n");}
	;

/*** Declaration ***/

declaration
	: declaration_specifiers ';' {

	}
	| declaration_specifiers init_declarator_list ';' {

	}
	;

declaration_specifiers
	:
       type_specifier
	| type_specifier declaration_specifiers


	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator {
	}
	;

init_declarator
	: declarator {
		$$ = $1;
	}
	| declarator '=' initializer {

		if ($3->init!="") $1->initialize($3->init);
        //if ($1->type->cat!=_MATRIX)
		emit (EQUAL, $1->name, $3->name);


	}
	;


type_specifier
	: VOID {
		TYPE = _VOID;
	}
	| CHAR {
		TYPE = _CHAR;
	}
	| SHORT
	| INT {
		TYPE = _INT;
	}
	| LONG
	| FLOAT
	| DOUBLE {
		TYPE = _DOUBLE;
	}
	| SIGNED
	| UNSIGNED
	| BOOL

    | MATRIX
        { TYPE=_MATRIX; }
	//{printf("type_specifier\n");}
	;







declarator
	: pointer direct_declarator {
		symtype * t = $1;
		while (t->ptr !=NULL) t = t->ptr;
		t->ptr = $2->type;
		$$ = $2->update($1);
	}
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER {
		$$ = $1->update(TYPE);

		currsym = $$;
	}
	| '(' declarator ')' {
		$$ = $2;
	}

	| direct_declarator '[' assignment_expression ']''[' assignment_expression ']'
        {

			    int x = atoi($3->symp->init.c_str());
			    symtype* s = new symtype(_MATRIX, $1->type, x);
                s->row=x;
                s->column=atoi($6->symp->init.c_str());
			    int y = sizeoftype(s);
			    $$ = $1->update(s);

	    }
	| direct_declarator '[' ']' {
		symtype * t = $1 -> type;
		symtype * prev = NULL;
		while (t->cat == ARR) {
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			symtype* s = new symtype(ARR, $1->type, 0);
			int y = sizeoftype(s);
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symtype(ARR, t, 0);
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator '['   assignment_expression ']'
	| direct_declarator '['  '*' ']'
	| direct_declarator '(' CST parameter_type_list ')' {
		table->tname = $1->name;

		if ($1->type->cat !=_VOID) {
			sym *s = table->lookup("retVal");
			s->update($1->type);
		}

		$1 = $1->linkst(table);

		table->parent = globalSymbolTable;
		changeTable (globalSymbolTable);				// Come back to globalsymbol table

		currsym = $$;
	}
	| direct_declarator '(' identifier_list ')' { /* Ignored */

	}
	| direct_declarator '(' CST ')' {
		table->tname = $1->name;			// Update function symbol table name

		if ($1->type->cat !=_VOID) {
			sym *s = table->lookup("retVal");// Update type of return value
			s->update($1->type);
		}

		$1 = $1->linkst(table);		// Update type of function in global table

		table->parent = globalSymbolTable;
		changeTable (globalSymbolTable);				// Come back to globalsymbol table

		currsym = $$;
	}
	;

CST : %empty { // Used for changing to symbol table for a function
		if (currsym->nest==NULL) changeTable(new symbolTable(""));	// Function symbol table doesn't already exist
		else {
			changeTable (currsym ->nest);						// Function symbol table already exists
			emit (LABEL, table->tname);
		}
	}
	;

pointer
	: '*' {
		$$ = new symtype(PTR);
	}

	| '*' pointer {
		$$ = new symtype(PTR, $2);
	}


	;




parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS

	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator {
		$2->category = "param";
	}
	| declaration_specifiers

	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER

	;





initializer_row_list:
                initializer_row
                { $$=$1;    }
            |   initializer_row_list ';' initializer_row
                {   rowison=true;
                    $$=$1;
                    $$->init=$1->init+";"+$3->init;}
        ;
initializer_row
	: initializer
        {   $$=$1;
        }
	| designation initializer
        {
            $$=$2;
        }
	| initializer_row ',' initializer
        {

            $$=$1;
            $$->init=$1->init+","+$3->init;
        }

	;
initializer
	: assignment_expression {
		$$ = $1->symp;
	}
	| '{' empty_token initializer_row_list '}'
        {

              $$=$3;
              string initial="{"+$3->init+"}";
              $$->init=initial;
              string rowS=$3->init;
              rowison=false;
               int ro=1,col=1;
               bool notfound=true;
              for(int i=0;i<rowS.size();i++)
                {
                    //cout<<rowS[i]<<endl;
                    if (rowS[i]==','&& notfound)
                        col++;
                    else if(rowS[i]==';')
                        {ro=ro+1;notfound=false;cout<<"HELLO "<<ro<<endl;}
                    else    ;
                }
             //sym* t=gentemp(_DOUBLE, initial);


                symtype *t=new symtype(_MATRIX,NULL,0);
                t->row=ro;
                t->column=col;
                cout<<t->row<<endl;
                sym *t1= gentemp(t,$$->init,true);
                $$->name=t1->name;;
        }

	;

empty_token:    %empty  {rowison=true;}

designation
	: designator_list '='

	;

designator_list
	: designator
	| designator_list designator


	;

designator
	: '[' constant_expression ']'
	| '.' IDENTIFIER

	;

statement
	: labeled_statement /* Skipped */
	| compound_statement {
		$$ = $1;

	}
	| expression_statement {
		$$ = new statement();
		$$->nextlist = $1->nextlist;

	}
	| selection_statement {
		$$ = $1;

	}
	| iteration_statement {
		$$ = $1;

	}
	| jump_statement {
		$$ = $1;

	}
	;

labeled_statement /* Ignored */
	: IDENTIFIER ':' statement {$$ = new statement();}
	| CASE constant_expression ':' statement {$$ = new statement();}
	| DEFAULT ':' statement {$$ = new statement();}
	;

compound_statement
	: '{' '}' { $$ = new statement();}
	| '{' block_item_list '}' {
		$$ = $2;
	}
	;

block_item_list
	: block_item {
		$$ = $1;
	}
	| block_item_list M block_item
        {
		    $$ = $3;
		    backpatch ($1->nextlist, $2);
        }
	;

block_item
	: declaration {
		$$ = new statement();

	}
	| statement {
		$$ = $1;

	}
	;

expression_statement
	: ';' {	$$ = new expr();}
	| expression ';' {
		$$ = $1;
	}
	;

selection_statement
	: IF '(' expression N')' M statement N {
		backpatch ($4->nextlist, nextinstr());
		convert2bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		list<int> temp = merge ($3->falselist, $7->nextlist);
		$$->nextlist = merge ($8->nextlist, temp);

	}
	| IF '(' expression N ')' M statement N ELSE M statement {
		backpatch ($8->nextlist, nextinstr());
		convert2bool($3);
        $$=new statement();
		backpatch ($3->truelist, $6);
		backpatch ($3->falselist, $10);
		list<int> temp = merge ($7->nextlist, $8->nextlist);
		$$->nextlist = merge (temp, $11->nextlist);
	}
	| SWITCH '(' expression ')' statement /* Skipped */
	{printf("selection_statement\n");}
	;

iteration_statement
	: WHILE M '(' expression ')' M statement {
		$$ = new statement();
		convert2bool($4);
		// M1 to go back to boolean again
		// M2 to go to statement if the boolean is true
		backpatch($7->nextlist, $2);
		backpatch($4->truelist, $6);
		$$->nextlist = $4->falselist;
		// Emit to prevent fallthrough
		emit (GOTOOP, tostr($2));
	}
	| DO M statement M WHILE '(' expression ')' ';' {
		$$ = new statement();
		convert2bool($7);
		// M1 to go back to statement if expression is true
		// M2 to go to check expression if statement is complete
		backpatch ($7->truelist, $2);
		backpatch ($3->nextlist, $4);

		// Some bug in the next statement
		$$->nextlist = $7->falselist;

	}
	| FOR '(' expression_statement M expression_statement ')' M statement {
		$$ = new statement();
		convert2bool($5);
		backpatch ($5->truelist, $7);
		backpatch ($8->nextlist, $4);
		emit (GOTOOP, tostr($4));
		$$->nextlist = $5->falselist;
	}
	| FOR '(' expression_statement M expression_statement M expression N ')' M statement {
		$$ = new statement();
		convert2bool($5);
		backpatch ($5->truelist, $10);
		backpatch ($8->nextlist, $4);
		backpatch ($11->nextlist, $6);
		emit (GOTOOP, tostr($6));
		$$->nextlist = $5->falselist;

	}
	;

jump_statement
	: GOTO IDENTIFIER ';' {$$ = new statement();}
	| CONTINUE ';' {$$ = new statement();}
	| BREAK ';' {$$ = new statement();}
	| RETURN ';' {
		$$ = new statement();
		emit(_RETURN,"");
	}
	| RETURN expression ';'{
		$$ = new statement();

			emit(_RETURN,$2->symp->name);

	}
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration {

	}
	;

external_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator declaration_list CST compound_statement {

	}
	| declaration_specifiers declarator CST compound_statement {
//		table->tname = $2->name;

//		$2 = $2->update(FUNC, table);
		table->parent = globalSymbolTable;
		changeTable (globalSymbolTable);
	}
	;
declaration_list
	: declaration
	| declaration_list declaration
	{printf("declaration_list\n");}
	;

%%

void yyerror(const char *s) {
	printf ("ERROR: %s",s);
}
