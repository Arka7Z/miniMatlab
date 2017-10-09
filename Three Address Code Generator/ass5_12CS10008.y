 %{

	#include <string.h>
	#include <stdio.h>
	#include "ass5_12CS10008_translator.h"
	extern	int yylex();
	void yyerror(const char *s);
	extern typeEnum TYPE;
	extern int gDebug;
    extern bool transRUN;
    extern bool rowison;

%}


%union {
	int integer_value;
	int instr;
	char* string_Value;
  statement* statAtt;
	float float_value;
	symb* symp;
	Expression* expAtt;
	symbolType* st;

	UnaryExpr* UnaryExpression;
	char unaryOP;	//UnaryExpr operator
}

%token MATRIX
%token VOID
%token CHAR SHORT SIGNED UNSIGNED INT LONG
%token DOUBLE FLOAT


%token BOOL
%token IF
%token ELSE
%token SWITCH
%token BREAK
%token CASE
%token CONTINUE
%token WHILE
%token DEFAULT
%token DO
%token RETURN
%token FOR
%token GOTO



%token <char> CHAR_CONSTANT
%token ELLIPSIS RIGHT_SHIFT_EQUAL DIV_EQUAL LESS_THAN_EQUAL
%token ADD_EQUAL
%token RIGHT_SHIFT LEFT_SHIFT
%token SUB_EQUAL
%token  MOD_EQUAL AND_EQUAL  OR_EQUAL

%token INCREMENT DECREMENT XOR_EQUAL ARROW AND_AND OR_OR LEFT_SHIFT_EQUAL
%token EQUALITY NOT_EQUAL_TO TRANSPOSE
%token GREATER_THAN_EQUAL MULT_EQUAL
%token <string_Value> STRING_LITERAL
%token <symp>IDENTIFIER  PUNCTUATORS COMMENT
%token <integer_value>INT_CONSTANT

%token <string_Value> FLOAT_CONSTANT


%start translation_unit

// Expressions
%type <UnaryExpression> unary_expression cast_expression postfix_expression



%type <expAtt>  expression  conditional_expression  logical_OR_expression assignment_expression
%type <expAtt>  expression_statement  primary_expression  empty_token relational_expression
%type <expAtt>  equality_expression  exclusive_OR_expression  inclusive_OR_expression
%type <expAtt>  	multiplicative_expression  additive_expression shift_expression  AND_expression logical_AND_expression





%type <unaryOP> unary_operator
%type <symp> constant initializer initializer_row_list designation
%type <symp> initializer_row

%type <instr> M
%type <expAtt> N
%type <st> pointer
%type <symp> direct_declarator init_declarator declarator
%type <integer_value> argument_expression_list

%type <statAtt>  statement  	jump_statement compound_statement block_item
%type <statAtt> labeled_statement	iteration_statement block_item_list selection_statement








%%
primary_expression
	:
  constant
  {
    $$ = new Expression();
    $$->symp = $1;
  }
  |IDENTIFIER
  {
		$$ = new Expression();
		$$->symp = $1;
		$$->isbool = isFalse();
	}

	| STRING_LITERAL {
		$$ = new Expression();
		$$->symp = gentemp(PTR, $1);
    string val($1);
    /////////////////////////
		$$->symp->initialize(val);
		$$->symp->type->ptr = new symbolType(_CHAR);
	}
	| '(' expression ')'
  {
		$$ = $2;
	}
	;

constant
	: INT_CONSTANT
  {
      string val=int2string($1);
      typeEnum type=_INT;
		$$ = gentemp(type, val);
    string name=$$->getName();
		emit(EQUAL, name, $1);
	}
	| FLOAT_CONSTANT
  {
        if (rowison==false)
        {
		$$ = gentemp(_DOUBLE, *new string ($1));
		emit(EQUAL, $$->name, *new string($1));
        }
        else
         {
            $$=new symb(*new string($1),_DOUBLE);
            $$->init=*new string($1);
           }
	}

	| CHAR_CONSTANT
  {
    typeEnum type=_CHAR;
    string flag("a");
		$$ = gentemp(type);
		emit(EQUAL, $$->name, type);
	}
	;

postfix_expression
	: primary_expression
  {
		$$ = new UnaryExpr ();
		$$->setSymp( $1->symp);
		$$->setLoc($$->symp);
		$$->setType( $1->symp->type);
        $$->setCat($$->type->cat);
	}
	| postfix_expression '[' expression ']''['expression']' {
		$$ = new UnaryExpr();

		$$->setSymp( $1->symp);			// copy the base
		$$->setType($1->type->ptr);		// type = type of element
		$$->setLoc(new symb("",_INT));		// store computed address

		if ($1->cat==_MATRIX) {
      typeEnum ty=_INT;
			symb* t = gentemp(ty);
 			emit(MULT, t->name, $3->symp->name, tostr(4));
            symb* t1=gentemp(_INT);
            emit(ARRR, t1->name, $1->symp->name,tostr(4));
            symb* t2=gentemp(_INT);
            emit(SUB,t2->name,t->name,tostr(4));
            symb* t3=gentemp(_INT);
            emit(MULT, t3->name, t2->name, t1->name);     //t5=t4*T3
            symb* t4=gentemp(_INT);
            emit(MULT, t4->name, $6->symp->name, tostr(4));  //t6=i*4
            symb* t5=gentemp(_INT);
            emit(ADD, t5->name,t3->name, t4->name);
            symb* t6=gentemp(_INT);
            emit(ADD, t6->name,t5->name,tostr(8));          //t8=t7+t8
            $$->loc->name=t6->name;

		}
 		else {
	 		emit(MULT, ($$->getLoc())->name, $3->symp->name, int2string(calculateSizeOfType($$->type)));
 		}

		$$->setCat(_MATRIX);
        ($$->getSymp())->type->cat=_MATRIX;

	}
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
  {
		$$ = new UnaryExpr();
    typeEnum type=$1->getType()->cat;
		$$->setSymp( gentemp(type));
    string name=$$->getSymp()->name;
    string name2=$1->getSymp()->name;
		emit(CALL, name, name2, tostr($3));
	}
	| postfix_expression '.' IDENTIFIER /* Ignored */
	| postfix_expression ARROW IDENTIFIER  /* Ignored */
	| postfix_expression INCREMENT {
		$$ = new UnaryExpr();

		// copy $1 to $$

         if ($1->symp->type->cat==_MATRIX)
        {
            symb* t1=gentemp(_DOUBLE);
            symb* t2=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$1->symp->name,$1->loc->name);
            emit(ARRR,t2->name,$1->symp->name,$1->loc->name);
            emit(ADD,t1->name,t1->name, "1");
            emit(ARRL,$1->symp->name,$1->loc->name,t1->name);
            $$->symp=t2;
        }
        else
        {
		    $$->setSymp( gentemp($1->getSymp()->type->cat));
		    emit (EQUAL, $$->symp->name, $1->getSymp()->name);

		    // Increment $1
		    emit (ADD, $1->getSymp()->name, $1->getSymp()->name, "1");
        }
	}
	| postfix_expression DECREMENT {
		$$ = new UnaryExpr();
         if ($1->getSymp()->type->cat==_MATRIX)
        {
            symb* t1=gentemp(_DOUBLE);
            symb* t2=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$1->symp->name,$1->loc->name);
            emit(ARRR,t2->name,$1->symp->name,$1->loc->name);
            emit(SUB,t1->name,t1->name, "1");
            emit(ARRL,$1->symp->name,$1->loc->name,t1->name);
            $$->symp=t2;
        }
        else
        {
		// copy $1 to $$
		$$->symp = gentemp($1->getSymp()->type->cat);
		emit (EQUAL, $$->symp->name, $1->getSymp()->name);

		// Decrement $1
		emit (SUB, $1->getSymp()->name, $1->getSymp()->name, "1");
        }
	}

    | postfix_expression TRANSPOSE{
            transRUN=true;

            symb* t=gentemp($1->type,"transpose");
            emit(TRANSOP,t->name,$1->symp->name);
            $$->symp=t;
        }
	;

argument_expression_list
	: assignment_expression {
		emit (PARAM, $1->getSymp()->name);
		$$ = 1;
	}
	| argument_expression_list ',' assignment_expression {
		emit (PARAM, $3->getSymp()->name);
		$$ = $1+1;
	}
	;

unary_expression
	: postfix_expression
    {
		$$ = $1;
	}
	| INCREMENT unary_expression
    {
        if ($2->symp->type->cat==_MATRIX)
        {
            symb* t1=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$2->symp->name,$2->loc->name);
            emit(ADD,t1->name,t1->name, "1");
            emit(ARRL,$2->symp->name,$2->loc->name,t1->name);

        }
        else
        {
          string arg=$2->getSymp()->name;
          string one=tostr(1);
		    emit (ADD,arg , arg, one);
        }
		$$ = $2;
	}
	| DECREMENT unary_expression {

         if ($2->symp->type->cat==_MATRIX)
        {
            symb* t1=gentemp(_DOUBLE);
            emit(ARRR,t1->name,$2->symp->name,$2->loc->name);
            emit(SUB,t1->name,t1->name, "1");
            emit(ARRL,$2->symp->name,$2->loc->name,t1->name);
        }
        else{
          string arg=$2->getSymp()->name;
          string one=tostr(1);
		// Decrement $1
		emit (SUB, arg, arg, one);
        }

		// Use the same value
		$$ = $2;
	}
	| unary_operator cast_expression {
		$$ = new UnaryExpr();
    string name1,name2;
		switch ($1) {
			case '&':
				        $$->setSymp ( gentemp(PTR));
				        $$->symp->type->ptr = $2->getSymp()->type;
                        if ($2->symp->type->cat==_MATRIX)
                            {
                                $$->symp->type->ptr=new symbolType(_DOUBLE);
                                string array_name=$2->symp->name;
                                string location=$2->loc->name;
                                emit(EQUAL, $$->symp->name,"&"+array_name+"["+location+"]" );
                            }
                        else
				            emit (ADDRESS, $$->getSymp()->name, $2->getSymp()->name);
				        break;
			case '*':
                        $$->setCat(PTR);
                        $$->setLoc(gentemp ($2->getSymp()->type->ptr));
                        name1=$$->getLoc()->name;
				        emit (PTRR, name1, $2->getSymp()->name);
				        $$->symp = $2->getSymp();
				        break;
			case '+':
				        $$ = $2;
				        break;
			case '-':
				        $$->setSymp(gentemp($2->getSymp()->type->cat));
                name1=$$->getSymp()->name;
				        emit (UNARYMINUS, name1, $2->getSymp()->name);
				        break;
			case '~':
				        $$->setSymp(gentemp($2->getSymp()->type->cat));
                name1=$$->symp->name;
                name2=$2->getSymp()->name;
				        emit (BINARYNOT, $$->symp->name, name2);
				        break;
			case '!':
				        $$->setSymp (gentemp($2->getSymp()->type->cat));
                name1=$$->symp->name;
                name2=$2->getSymp()->name;
				        emit (LNOT, name1, name2);
				        break;
			default:
				        break;
		}
	}
;

unary_operator
	:
   '!' {

        setUnaryOp($$,'!');
  }
	| '*' {

        setUnaryOp($$,'*');
	}

	| '-' {

        setUnaryOp($$,'-');
	}
	| '&' {

    setUnaryOp($$,'&');
	}
  |'~' {

        setUnaryOp($$,'~');
	}

  | '+' {

        setUnaryOp($$,'+');
  }
	;

cast_expression
	: unary_expression
   {
		$$ = $1;
	}

	;

multiplicative_expression
	: cast_expression
        {
		$$ = new Expression();
    typeEnum catTemp=$1->getCat();
		if ($1->cat==_MATRIX) { // Array

            if (transRUN==false)
               {
                symbolType *t=new symbolType($1->cat,NULL,0);
                t->row=($1->symp->type->row);
                t->column=($1->symp->type->column);
                $$->symp = gentemp(t,"Mat_temp");
			  emit(ARRR, $$->symp->name, $1->symp->name, $1->loc->name);
                }
            else
                {
                    //$$->symp = gentemp($1->type,"transpose");
                    $$->setSymp ($1->symp);
                }
		}
		else if (catTemp==PTR) { // Pointer
			$$->setSymp ( $1->loc);
		}
		else { // otherwise
			$$->setSymp($1->symp);
		}
	}
	| multiplicative_expression '*' cast_expression
  {

		if (typecheck ($1->symp,$3->symp))
    {
			$$ = new Expression();
			$$->setSymp(gentemp(($1->getSymp())->type->cat));
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (MULT, $$->symp->name, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	| multiplicative_expression '/' cast_expression{
		if (typecheck ($1->symp, $3->symp) ) {
			$$ = new Expression();
      $$->setSymp(gentemp($1->getSymp()->type->cat));
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (DIVIDE, $$->symp->name, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	| multiplicative_expression '%' cast_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			$$ = new Expression();
      $$->setSymp(gentemp($1->getSymp()->type->cat));
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (MODULUS, $$->symp->name, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	;

additive_expression
	: multiplicative_expression {$$ = $1;}
	| additive_expression '+' multiplicative_expression
  {
		if (typecheck($1->symp, $3->symp))
    {
			$$ = new Expression();

      $$->setSymp(gentemp($1->getSymp()->type->cat));
      string res=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (ADD, res, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	| additive_expression '-' multiplicative_expression {
		if (typecheck($1->symp, $3->symp))
    {
			$$ = new Expression();
      $$->setSymp(gentemp($1->getSymp()->type->cat));
      string res=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (SUB, res, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	;

shift_expression
	: additive_expression {$$ = $1;}
	| shift_expression LEFT_SHIFT additive_expression
  {
    typeEnum intType=_INT;
    typeEnum cat=$3->symp->type->cat;
		if (cat == intType)
    {
			$$ = new Expression();
			$$->setSymp(gentemp (intType));
      string res=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit (LEFTSHIFT, res, name1, name2);

		}
		else cout << "Type Error"<< endl;
	}
	| shift_expression RIGHT_SHIFT additive_expression
  {typeEnum intType=_INT;
      typeEnum cat=$3->symp->type->cat;
		if (cat == intType) {
			$$ = new Expression();
      $$->setSymp(gentemp (intType));
      string res=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit (RIGHTSHIFT, res, name1, name2);

		}
		else cout << "Type Error"<< endl;
	}
	;

relational_expression
	: shift_expression
  {
    $$ = $1;
  }
	| relational_expression '<' shift_expression {
		if (typecheck ($1->symp, $3->symp) )
     {
			// New bool
			$$ = new Expression();
			$$->setIsBool(true);

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
      string nullstring="";
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit(LT, nullstring, name1, name2);
			emit (GOTOOP, nullstring);
		}
		else cout << "Type Error"<< endl;
	}
	| relational_expression '>' shift_expression
  {
		if (typecheck ($1->symp, $3->symp) )
    {
			// New bool
			$$ = new Expression();
			$$->setIsBool(true);

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
      string nullstring="";
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit(GreaterThan, nullstring, name1, name2);
      emit (GOTOOP, nullstring);

		}
		else cout << "Type Error"<< endl;
	}
	| relational_expression LESS_THAN_EQUAL shift_expression
  {
		if (typecheck ($1->symp, $3->symp) )
    {
			// New bool
			$$ = new Expression();
			$$->setIsBool(true);

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
      string nullstring="";
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit(LE, nullstring, name1, name2);
      emit (GOTOOP, nullstring);
		}
		else cout << "Type Error"<< endl;
	}
	| relational_expression GREATER_THAN_EQUAL shift_expression {
		if (typecheck ($1->symp, $3->symp) )
    {
			// New bool
			$$ = new Expression();
			$$->setIsBool(true);
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
      string nullstring="";
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit(GREATERTHANEQ, nullstring, name1, name2);
      emit (GOTOOP, nullstring);
		}
		else cout << "Type Error"<< endl;
	}
	;

equality_expression
	: relational_expression {$$ = $1;}
	| equality_expression EQUALITY relational_expression {
		if (typecheck ($1->symp, $3->symp) )
    {
			// If any is bool get its value
			convertfrombool ($1);
			convertfrombool ($3);

			$$ = new Expression();
			$$->setIsBool(true);

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
      string nullstring="";
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit(EQOP, nullstring, name1, name2);
      emit (GOTOOP, nullstring);

		}
		else cout << "Type Error"<< endl;
	}
	| equality_expression NOT_EQUAL_TO relational_expression {
		if (typecheck ($1->symp, $3->symp) ) {
			// If any is bool get its value
			convertfrombool ($1);
			convertfrombool ($3);

			$$ = new Expression();
			$$->setIsBool(true);

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
      string nullstring="";
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
      emit(NEOP, nullstring, name1, name2);
      emit (GOTOOP, nullstring);
	;
		}
		else cout << "Type Error"<< endl;
	}
	;

AND_expression
	: equality_expression {$$ = $1;}
	| AND_expression '&' equality_expression {
		if (typecheck ($1->symp, $3->symp) )
    {
			$$ = new Expression();
			$$->setIsBool(false);

			$$->setSymp(gentemp (_INT));
      string name=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (BINARYAND, name, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	;

exclusive_OR_expression
	: AND_expression {$$ = $1;}
	| exclusive_OR_expression '^' AND_expression {
		if (typecheck ($1->symp, $3->symp) )

    {
			// If any is bool get its value
			convertfrombool ($1,$3);
		   $$ = new Expression();


			$$->setIsBool(false);
      $$->setSymp(gentemp (_INT));
      string name=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (XOR, name, name1, name2);
		}
		else cout << "Type Error"<< endl;
	}
	;

inclusive_OR_expression
	: exclusive_OR_expression {$$ = $1;}
	| inclusive_OR_expression '|' exclusive_OR_expression {
		if (typecheck ($1->symp, $3->symp) )

    {
			// If any is bool get its value

			convertfrombool ($1,$3);
      $$ = new Expression();

			$$->setIsBool(false);
      $$->setSymp(gentemp (_INT));
      string name=$$->getSymp()->name;
      string name1=$1->getSymp()->name;
      string name2=$3->getSymp()->name;
			emit (INCLUSIVEOR, name, name1, name2);

		}
		else cout << "Type Error"<< endl;
	}
	;

logical_AND_expression
	: inclusive_OR_expression
  {
    $$ = $1;
  }
	| logical_AND_expression N AND_AND M inclusive_OR_expression
  {
		covertToBoolean($5);

		// N to convert $1 to bool
		backpatch($2->nextlist, nextinstr());
		covertToBoolean($1);
    $$ = new Expression();

    $$->setIsBool(true);

		backpatch($1->getTruelist(), $4);
		$$->setTruelist($5->getTruelist());
		$$->setFalselist (merge ($1->falselist, $5->falselist));
	}
	;

logical_OR_expression
	: logical_AND_expression {$$ = $1;}
	| logical_OR_expression N OR_OR M logical_AND_expression {
		covertToBoolean($5);

		// N to convert $1 to bool
		backpatch($2->nextlist, nextinstr());
		covertToBoolean($1);
    $$ = new Expression();

		$$->setIsBool(true);

		backpatch ($$->getFalselist(), $4);
		$$->setTruelist( merge ($1->truelist, $5->truelist));
		$$->setFalselist($5->falselist);
	}
	;

M 	: %empty{	// To store the address of the next instruction for further use.
		$$ = nextinstr();
	};

N 	: %empty { 	// Non terminal to prevent fallthrough by emitting a goto

		$$  = new Expression();
		$$->nextlist = makelist(nextinstr());
    string nullstring="";
		emit (GOTOOP,nullstring);

	}

conditional_expression
	: logical_OR_expression {$$ = $1;}
	| logical_OR_expression N '?' M expression N ':' M conditional_expression
  {
//		covertToBoolean($5);
		$$->setSymp( gentemp());
		($$->getSymp())->update($5->getSymp()->type);
    string res=$$->getSymp()->name;
    string arg=$9->getSymp()->name;









		emit(EQUAL, res, arg);
		li l = makelist(nextinstr());
    string nullstring="";
		emit (GOTOOP,nullstring);

		backpatch($6->nextlist, nextinstr());
    res=$$->getSymp()->name;
    arg=$5->getSymp()->name;
		emit(EQUAL, res, arg);
		li m = makelist(nextinstr());
		l = merge (l, m);
		emit (GOTOOP, nullstring);

		backpatch($2->nextlist, nextinstr());
		covertToBoolean ($1);

		backpatch ($1->getTruelist(), $4);
		backpatch ($1->getFalselist(), $8);

		backpatch (l, nextinstr());
	}
	;

assignment_expression
	: conditional_expression
  {
		$$ = $1;
	}
	| unary_expression assignment_operator assignment_expression {///////////////////
    typeEnum category=$1->getCat();

    if (category==_MATRIX)
    {
        $3->symp = conv($3->symp, $1->type->cat);
        if (transRUN==false)
            emit(ARRL, $1->symp->name, $1->loc->name, $3->symp->name);
        else
            {
                  emit(EQUAL, $1->symp->name,$3->symp->name);
                  transRUN=false;
            }
    }
    else if(category==PTR)
    {
      emit(PTRL, $1->symp->name, $3->symp->name);

    }
    else
    {
      $3->symp = conv($3->symp, $1->symp->type->cat);
      emit(EQUAL, $1->symp->name, $3->symp->name);
    }
		$$ = $3;
	}
	;

assignment_operator
	: MULT_EQUAL |'='| OR_EQUAL| LEFT_SHIFT_EQUAL  | DIV_EQUAL | MOD_EQUAL | ADD_EQUAL  | AND_EQUAL | SUB_EQUAL | RIGHT_SHIFT_EQUAL| XOR_EQUAL

	;

expression
	: assignment_expression {
		$$ = $1;}
	| expression ',' assignment_expression

	;

constant_expression : conditional_expression;

/*** Declaration ***/

declaration
	: declaration_specifiers ';' {}
	| declaration_specifiers init_declarator_list ';' {}
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
	: VOID {TYPE = _VOID;	}
	| CHAR {
		TYPE = _CHAR;
	}
	| SHORT
  {
    ;
  }
  | MATRIX
          { TYPE=_MATRIX; }
	| INT
  {
		TYPE = _INT;
	}
	| LONG
	| FLOAT
  {
    ;
  }
	| DOUBLE {
		TYPE = _DOUBLE;
	}
	| SIGNED
	| UNSIGNED
	| BOOL
  {
    ;
  }

	;







declarator
	: pointer direct_declarator {
		symbolType * t = $1;
		for(;t->ptr !=NULL; t = t->ptr)
          ;
		t->ptr = $2->type;
		$$ = $2->update($1);
	}
	| direct_declarator;

direct_declarator
	: IDENTIFIER {$$ = $1->update(TYPE);currentSymbol = $$;}
	| '(' declarator ')' {$$ = $2;
	}

	| direct_declarator '[' assignment_expression ']''[' assignment_expression ']'
        {

			    int x = atoi($3->symp->init.c_str());
			    symbolType* s = new symbolType(_MATRIX, $1->type, x);
                s->row=x;
                s->column=atoi($6->symp->init.c_str());
			    int y = calculateSizeOfType(s);
			    $$ = $1->update(s);

	    }
	| direct_declarator '[' ']' {
		/*symbolType * t = $1 -> type;
		symbolType * prev = NULL;
		while (t->cat == ARR) {
			prev = t;
			t = t->ptr;
		}*/
    symbolType * t = $1 -> type;
    symbolType * prev = NULL;

    for(;t->cat==ARR;prev=t,t=t->ptr)
    ;
		if (prev==NULL)
    {
			symbolType* s = new symbolType(ARR, $1->type, 0);
			int y = calculateSizeOfType(s);
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symbolType(ARR, t, 0);
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator '['   assignment_expression ']' | direct_declarator '['  '*' ']'
	| direct_declarator '(' CST parameter_type_list ')'
  {
    string funcName=$1->getName();
    table->setTableName(funcName);
    typeEnum returnCat=$1->getType()->cat;
		if (returnCat !=_VOID)
    {
			symb *s = table->lookup("retVal");
			s->update($1->type);
		}

		$1 = $1->linkst(table);

		table->setParent(globalSymbolTable);
		changeTable (globalSymbolTable);				// Come back to globalsymbol table

		currentSymbol = $$;
	}
	| direct_declarator '(' identifier_list ')' 	| direct_declarator '(' CST ')' {
    string funcName=$1->getName();
    table->setTableName(funcName);			// Update function symbol table name
    typeEnum returnCat=$1->getType()->cat;
		if (returnCat !=_VOID) {
			symb *s = table->lookup("retVal");// Update type of return value
			s->update($1->type);
		}

		$1 = $1->linkst(table);		// Update type of function in global table

		table->setParent(globalSymbolTable);
		changeTable (globalSymbolTable);				// Come back to globalsymbol table

		currentSymbol = $$;
	}
	;

CST : %empty { // Used for changing to symbol table for a function
		if (currentSymbol->nest==NULL) changeTable(new symbolTable(""));	// Function symbol table doesn't already exist
		else {
			changeTable (currentSymbol ->nest);						// Function symbol table already exists
      string tableName=table->getTableName();
			emit (LABEL,tableName);
		}
	}
	;

pointer
	: '*' {$$ = new symbolType(PTR);}

	| '*' pointer {$$ = new symbolType(PTR, $2);}


	;




parameter_type_list
	: parameter_list


	;

parameter_list
	: parameter_declaration | parameter_list ',' parameter_declaration
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
             //symb* t=gentemp(_DOUBLE, initial);


                symbolType *t=new symbolType(_MATRIX,NULL,0);
                t->row=ro;
                t->column=col;
                cout<<t->row<<endl;
                symb *t1= gentemp(t,$$->init,true);
                $$->name=t1->name;;
        }

	;

empty_token:    %empty  {rowison=true;}

designation
	: designator_list '='

	;

designator_list
	: designator | designator_list designator


	;

designator
	:
	 '.' IDENTIFIER |
  '[' constant_expression ']'
	;

statement
	: labeled_statement
  | compound_statement {
    ($$=$1);
  }
	| expression_statement {
		$$ = new statement();
		$$->setNextlist( $1->nextlist);

	}
	| selection_statement                {
		                                       ($$=$1);

	                                       }
	| iteration_statement                 {
		                                       ($$=$1);
                                        }
	| jump_statement                     {
		                                       ($$=$1);

	                                     }
	;

labeled_statement /* Ignored */
	: IDENTIFIER ':' statement {$$ = new statement();}
	| CASE constant_expression ':' statement {$$ = new statement();}
	| DEFAULT ':' statement {$$ = new statement();}
	;

compound_statement
	: '{' '}' { $$ = new statement();}
  | '{' block_item_list '}'
  {
    ($$=$2);
  };

block_item_list
	: block_item {
		($$=$1);
	}
	| block_item_list M block_item
        {
		    ($$=$3);
		    backpatch ($1->getNextlist(), $2);
        }
	;

block_item
	: declaration
                                  {
                                              $$ = new statement();
                                  }
	| statement
  {       ($$=$1);

	}
	;

expression_statement
	: ';' {	$$ = new Expression();}
	| expression ';'
  {
    $$ = $1;
  }
	;

selection_statement
	: IF '(' expression N')' M statement N {
    li n1=$4->nextlist;
		backpatch (n1, nextinstr());

		covertToBoolean($3);

		$$ = new statement();
    li expressionList=$3->truelist;
		backpatch (expressionList, $6);

		$$->setNextlist(merge ($3->falselist, $7->nextlist,$8->nextlist));

	}
	| IF '(' expression N ')' M statement N ELSE M statement {
		backpatch ($8->nextlist, nextinstr());
		covertToBoolean($3);
        $$=new statement();
		backpatch ($3->truelist, $6);
		backpatch ($3->falselist, $10);
    li tmp= merge ($7->nextlist, $8->nextlist);
    li tmp2=merge (tmp, $11->nextlist);
		$$->setNextlist(tmp2);
	}
	| SWITCH '(' expression ')' statement /* Skipped */

	;

iteration_statement
	: WHILE M '(' expression ')' M statement {
		$$ = new statement();
		covertToBoolean($4);
    li statementList=$7->nextlist;
		backpatch(statementList, $2);
    li expressionList=$4->getTruelist();
		backpatch(expressionList, $6);
		$$->nextlist = $4->getFalselist();
		// Emit to prevent fallthrough
    string two=SSTR($2);
		emit (GOTOOP, two);
	}
	| DO M statement M WHILE '(' expression ')' ';' {
		$$ = new statement();

		covertToBoolean($7);


		backpatch ($7->truelist, $2);
		backpatch ($3->nextlist, $4);

		// Some bug in the next statement
		$$->setNextlist($7->falselist);

	}
	| FOR '(' expression_statement M expression_statement ')' M statement {
		$$ = new statement();
		covertToBoolean($5);
    li exp2List=$5->getTruelist();
		backpatch (exp2List, $7);
    li statementList=$8->nextlist;
		backpatch (statementList, $4);
    string four=SSTR($4);
		emit (GOTOOP, four);
		$$->setNextlist($5->falselist);
	}
	| FOR '(' expression_statement M expression_statement M expression N ')' M statement {
		$$ = new statement();
		covertToBoolean($5);
    li exp2List=$5->getTruelist();
		backpatch (exp2List, $10);
    li nList=$8->nextlist;
		backpatch (nList, $4);
    li statementList=$11->nextlist;
		backpatch (statementList, $6);
    string six=SSTR($6);
		emit (GOTOOP, six);
		$$->setNextlist($5->falselist);

	}
	;

jump_statement
	: GOTO IDENTIFIER ';' {$$ = new statement();}
	| CONTINUE ';' {$$ = new statement();}
	| BREAK ';' {$$ = new statement();}
	| RETURN ';'
  {
		$$ = new statement();
    string nullstring="";
		emit(_RETURN,nullstring);
	}
	| RETURN expression ';'{
		$$ = new statement();
      string retName=$2->getSymp()->name;
			emit(_RETURN,retName);

	}
	;

translation_unit
	: external_declaration | translation_unit external_declaration	;

external_declaration
	: function_definition | declaration ;

function_definition
	: declaration_specifiers declarator declaration_list CST compound_statement {

	}
	| declaration_specifiers declarator CST compound_statement
  {

		table->setParent( globalSymbolTable);
		changeTable (globalSymbolTable);
	}
	;
declaration_list
	: declaration| declaration_list declaration	;

%%

void yyerror(const char *s) {
	printf ("ERROR: %s",s);
}
