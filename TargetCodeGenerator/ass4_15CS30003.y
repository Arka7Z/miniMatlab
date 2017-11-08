%{

 #include <string.h>
 #include <stdio.h>
 #include "ass4_15CS30003_translator.h"
 extern	int yylex();
 void yyerror(const char *s);
 extern typeEnum TYPE;
 extern int gDebug;
 extern bool transRUN;
 extern bool rowison;
 vector <string> allstrings;
 vector <init_double> alldoubles;
 /*
 Explanation of Attributes:
 ~~~~~~~~~~~~~~~~~~~~~~~~~

 integer_value: stores the integer(number) in INT_CONSTANT.
 instr:         stores the index of the next instruction (used in backpatching) for token M.
 string_Value:  stores the string literal of STRING_LITERAL token and float value(as a string) of FLOAT_CONSTANT token.
 statAtt:       stores nextlist for backcpatching of non-terminals statement, labeled_statement, compound_statement, selection_statement,
                iteration_statement, jump_statement, block_item, block_item_list.
 symp:          stores the pointer to the symbol table entry for IDENTIFIER, direct_declarator,init_declarator, declarator
                Used for example during declaration of variables or functions etc.
 expAtt:        Stores the Attributes of an expression such as pointer to symbol table entry(for non-conditional expressions)
                and Attributes such as nextlist, truelist, falselist(for conditional expressions)
                Used for non-terminals 	expression,primary_expression,multiplicative_expression,additive_expression,shift_expression, relational_expression
                equality_expression,and_expression,exclusive_or_expression,inclusive_or_expression,logical_and_expression,logical_or_expression
                conditional_expression,assignment_expression,expression_statement
 st:            Attribute for pointer to store the type of entity pointed to by the pointer
 charConst:     Stores the character(as string) for CHAR_CONSTANT
 UnaryExpression: Attribute to store different things including pointer to symbol table entry and index tranlation for matrix elements
                  Used in non-terminals unary_expression, cast_expression, postfix_expression
 unaryOP:         stores the unary operators like '*','&' for unary_operator non-terminal

 %tokens used in the parser correpond to operators, constants, keywords etc and their meanings can be well derived from their names.

 AUGMENTATIONS:
 ~~~~~~~~~~~~~
 Non-Terminals used for augmentation: M, N, CST, empty_token
 Usage:
       * M, N:         Used for detecting the address the nextlists, truelist, falselist etc are to be backpatched to.
       * CST:          Used for nesting symbol tables while parsing function definitions.
       * empty_token:  To initialize a flag rowison to True which indicates a matrix declaration is taking place.

 */

%}


%union {
 int integer_value;
 int instr;
 char* string_Value;
 statement* statAtt;
 symb* symp;
 Expression* expAtt;
 symbolType* st;
 char* charConst;
 UnaryExpr* UnaryExpression;
 char unaryOP;
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



%token ELLIPSIS RIGHT_SHIFT_EQUAL DIV_EQUAL LESS_THAN_EQUAL
%token ADD_EQUAL
%token RIGHT_SHIFT LEFT_SHIFT
%token SUB_EQUAL
%token  MOD_EQUAL AND_EQUAL  OR_EQUAL

%token INCREMENT DECREMENT XOR_EQUAL ARROW AND_AND OR_OR LEFT_SHIFT_EQUAL
%token EQUALITY NOT_EQUAL_TO TRANSPOSE
%token GREATER_THAN_EQUAL MULT_EQUAL
%token <string_Value> STRING_LITERAL
%token <symp>IDENTIFIER
%token <integer_value>INT_CONSTANT

%token <string_Value> FLOAT_CONSTANT
%token<charConst> CHAR_CONSTANT

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
primary_expression                                                    // reduces constants, identifiers, string literals and parenthesized expressions
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


   $$->symp->initialize($1);
   allstrings.push_back($1);
   emit(EQUALSTR, $$->symp->name, tostr (allstrings.size()-1));
 }
 | '(' expression ')'
 {
   $$ = $2;
 }
 ;

constant                                                       // Here temporaries of the appropriate type(int,char,float) are generated and the initial value is stored
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
   init_double init_d;
   init_d.d_value = atof($1);
   init_d.name=$$->name;
   alldoubles.push_back(init_d);
   emit(EQUAL_DOUBLE, $$->name, *new string($1));
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
   /*string flag("a");*/
       string charName=SSTR($1);
   $$ = gentemp(type,charName);
   /*cout<<"here hre "<<$1<<endl;*/
   emit(EQUALCHAR, $$->name,tostr($1));

 }
 ;

postfix_expression
 : primary_expression
 {                                                                           // synthesized Attributes such as location and symp of postfix_expression are set
   $$ = new UnaryExpr ();
   $$->setSymp( $1->symp);
   $$->setLoc($$->symp);
$$->setType( $1->symp->type);
       $$->setCat($$->type->cat);
 }
 | postfix_expression '[' expression ']''['expression']' {                   // Matrix type is handled here separately which includes
   $$ = new UnaryExpr();                                                     // translating the matrix indices to appropriate memory locations

   $$->setSymp( $1->symp);			// copy the base
   $$->setType($1->type->ptr);		// type = type of element

  $$->setLoc(new symb("",_INT));		// store computed address

   if ($1->cat==_MATRIX) {
     typeEnum ty=_INT;
     symb* t = gentemp(ty);

      int colSize=(table->lookup($1->symp->name))->type->column;
      symb* p=gentemp(ty);
      emit(MULT, p->name, $3->symp->name, tostr(8*colSize));
      //symb* p1=gentemp(ty);
    //  emit(ADD,p1->name,$1->symp->name,p->name);
      symb* p2=gentemp(ty);
      emit(MULT, p2->name, $6->symp->name, tostr(8));
      symb* p3=gentemp(ty);
      emit(ADD,p3->name,p->name,p2->name);

      symb* useles=gentemp(_DOUBLE);


           /*emit(MULT, t->name, $3->symp->name, tostr(4));
           symb* t1=gentemp(_INT);
           emit(ARRR, t1->name, $1->symp->name,tostr(4));
           symb* t2=gentemp(_INT);
           emit(SUB,t2->name,t->name,tostr(4));
           symb* t3=gentemp(_INT);
           emit(MULT, t3->name, t2->name, t1->name);                           //t5=t4*T3
           symb* t4=gentemp(_INT);
           emit(MULT, t4->name, $6->symp->name, tostr(4));                     //t6=i*4
           symb* t5=gentemp(_INT);
           emit(ADD, t5->name,t3->name, t4->name);
           symb* t6=gentemp(_INT);
           emit(ADD, t6->name,t5->name,tostr(8));                              //t8=t7+t8*/

           $$->loc->name=p3->name;
           $$->setCat(_MATRIX);
               $$->getSymp()->type->cat=_MATRIX;
               //$$->type->cat=_DOUBLE;

   }
   else {
     emit(MULT, ($$->getLoc())->name, $3->symp->name, int2string(calculateSizeOfType($$->type)));
   }

   $$->setCat(_MATRIX);
       $$->getSymp()->type->cat=_MATRIX;
       /*$$->type->cat=_DOUBLE;*/



 }
 | postfix_expression '(' ')'
 | postfix_expression '(' argument_expression_list ')'
 {                                                                             // function calls are handled here
   $$ = new UnaryExpr();
   typeEnum type=$1->getType()->cat;
   $$->setSymp( gentemp(type));
   string name=$$->getSymp()->name;
   string name2=$1->getSymp()->name;
   emit(CALL, name, name2, tostr($3));
 }
 | postfix_expression '.' IDENTIFIER /* Ignored */
 | postfix_expression ARROW IDENTIFIER  /* Ignored */
 | postfix_expression INCREMENT {                                              // Matrix type is handled separately
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
        if ($1->getSymp()->type->cat==_MATRIX)                                 // Matrix type is handled separately
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

   | postfix_expression TRANSPOSE{                                          // Handling matrix transpose operation where a temp is generated which
           transRUN=true;                                                   // stores the transposed matrix and is later assigned to the lhs matrix of transpose op.
           symb* t=gentemp($1->type,"transpose");
           emit(TRANSOP,t->name,$1->symp->name);
           $$->symp=t;
       }
 ;

argument_expression_list
 : assignment_expression {                                                  // generating quads for function call parameters( param)
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
   {                                                                         // Unary Expressions are handled here and matrix elements have been handled separately
   $$ = $1;                                                                 // where necessary as they need access to the temporary(in loc) that stores the index translation.
 }
 | INCREMENT unary_expression
   {
       if ($2->symp->type->cat==_MATRIX)
       {
           symb* t1=gentemp(_DOUBLE);
           emit(ARRR,t1->name,$2->symp->name,$2->loc->name);
           emit(ADD,t1->name,t1->name, "1");
           emit(ARRL,$2->symp->name,$2->loc->name,t1->name);                // Attribute loc stores the temporary which has the final translation of matrix indices
                                                                           // For example: t in m[t] where m is a Matrix.
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
           emit(ARRL,$2->symp->name,$2->loc->name,t1->name);               // Attribute loc stores the temporary which has the final translation of matrix indices
                                                                           // For example: t in m[t] where m is a Matrix.
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
     case '&':                                                          // Handling unary operators (matrix type is handled separately here as well the way mentioned above)
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

               if ($2->symp->type->cat==_MATRIX)
               {
                 symbolType *t=new symbolType($2->cat,NULL,0);
                 t->row=($2->symp->type->row);
                 t->column=($2->symp->type->column);
                 int row=t->row;
                 int col=t->column;
                 $$->symp = gentemp(t,"Mat_temp");
                 $$->symp->type->row=row;
                 $$->symp->type->column=col;
                 $$->symp->size=(row*col*size_of_double)+8;
               }
               else
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
                                                                           // assigns the unary operator string such as'-,'&' etc to unary_operator
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
  {                                                                            // Copy all the Attributes
   $$ = $1;
 }

 ;


 /*Each Expression of the form multiplicative_expression binary_operator cast_expression is typechecked
 for determining compatibility wrt the operation*/

multiplicative_expression
 : cast_expression
       {
         cout<<"multiplicative_expression->CAST"<<endl;
   $$ = new Expression();
   typeEnum catTemp=$1->getCat();
   if ($1->cat==_MATRIX)
   {                                                             // Matrix

                         /*If a matrix transpose operation is currently runnig(indicated by the transRUN flag)
                         then the dimensions of the temporary generated
                         are handled separately*/

           if (transRUN==false)

              {
                    /*if ($1->type->cat==_DOUBLE)
                    {*/

                      $$->symp=gentemp(_DOUBLE);
                     emit(ARRR, $$->symp->name, $1->symp->name, $1->loc->name);

                     /*}
                     else
                     {
                       symbolType *t=new symbolType($1->cat,NULL,0);
                       /*cout<<"I am here"<<endl;*/
                       /*t->row=($1->symp->type->row);
                       t->column=($1->symp->type->column);
                       int row=t->row;
                       int col=t->column;
                       $$->symp = gentemp(t,"Mat_temp");
                       $$->symp->type->row=row;
                       $$->symp->type->column=col;
                       $$->symp->size=(row*col*size_of_double+8);
                       emit(ARRR, $$->symp->name, $1->symp->name, $1->loc->name);
                     }*/
               }
           else
               {
                   //$$->symp = gentemp($1->type,"transpose");
                   $$->setSymp ($1->symp);
               }
   }
   else if (catTemp==PTR) {                                   // Handling the case of pointers separately
     $$->setSymp ( $1->loc);
   }
   else { // otherwise
     $$->setSymp($1->symp);
   }
 }
 | multiplicative_expression '*' cast_expression
 {

   if (typecheck ($1->symp,$3->symp))                                 // Handling Type Check
   {
     $$ = new Expression();
     int row,col;
     if ($1->symp->type->cat==_MATRIX && $3->symp->type->cat==_MATRIX)
       {
             symbolType *t=new symbolType($1->symp->type->cat,NULL,0);
             row=$1->symp->type->row;
             col=$3->symp->type->column;
             $$->symp = gentemp(t,"Mat_temp");
       }
       else if ($1->symp->type->cat!=_MATRIX && $3->symp->type->cat==_MATRIX)
       {
         symbolType *t=new symbolType($3->symp->type->cat,NULL,0);
         /*cout<<"IAM IN"<<endl;*/
         row=$3->symp->type->row;
         col=$3->symp->type->column;
         $$->symp = gentemp(t,"Mat_temp");
       }
       else if ($1->symp->type->cat==_MATRIX && $3->symp->type->cat!=_MATRIX)
       {
         symbolType *t=new symbolType($1->symp->type->cat,NULL,0);
         row=$1->symp->type->row;
         col=$1->symp->type->column;
         $$->symp = gentemp(t,"Mat_temp");
       }
       else
            $$->setSymp(gentemp(($1->getSymp())->type->cat));
       if ($1->symp->type->cat==_MATRIX || $3->symp->type->cat==_MATRIX)
       {
         $$->symp->type->row=row;
         $$->symp->type->column=col;
         $$->symp->size=(row*col*size_of_double+8);
       }

     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;

     emit (MULT, $$->symp->name, name1, name2);
   }
   else cout << "Type Error"<< endl;
 }
 | multiplicative_expression '/' cast_expression{
   if (typecheck ($1->symp, $3->symp) ) {                            // Handling Type Check
     $$ = new Expression();
     $$->setSymp(gentemp($1->getSymp()->type->cat));
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit (DIVIDE, $$->symp->name, name1, name2);
   }
   else cout << "Type Error"<< endl;
 }
 | multiplicative_expression '%' cast_expression {
   if (typecheck ($1->symp, $3->symp) ) {                            // Handling Type Check
     $$ = new Expression();
     $$->setSymp(gentemp($1->getSymp()->type->cat));
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit (MODULUS, $$->symp->name, name1, name2);
   }
   else cout << "Type Error"<< endl;
 }
 ;


 /*Each Expression of the form  additive_expression [+-] multiplicative_expression is typechecked
 for determining compatibility wrt the operation*/

additive_expression
 : multiplicative_expression {$$ = $1;}
 | additive_expression '+' multiplicative_expression                         // change to
 {
   if (typecheck($1->symp, $3->symp))                          // Handling Type Check
   {
      cout<<"HERE ADD ADD"<<endl;
     $$ = new Expression();

     int row,col;

        if ($1->symp->type->cat!=_MATRIX && $3->symp->type->cat==_MATRIX)
       {
         symbolType *t=new symbolType($3->symp->type->cat,NULL,0);
         row=$3->symp->type->row;
         col=$3->symp->type->column;
         $$->symp = gentemp(t,"Mat_temp");
       }
       else if ($1->symp->type->cat==_MATRIX && $3->symp->type->cat!=_MATRIX)
       {
         symbolType *t=new symbolType($1->symp->type->cat,NULL,0);
         row=$1->symp->type->row;
         col=$1->symp->type->column;
         $$->symp = gentemp(t,"Mat_temp");
       }
       else
            {$$->setSymp(gentemp(($1->getSymp())->type->cat));
              //cout<<"HERE"<<endl;
            }

       if ($1->symp->type->cat==_MATRIX && $3->symp->type->cat!=_MATRIX)
       {
         $$->symp->type->row=row;
         $$->symp->type->column=col;
         $$->symp->size=(row*col*size_of_double)+8;
       }
       else if($1->symp->type->cat!=_MATRIX && $3->symp->type->cat==_MATRIX)
       {
         $$->symp->type->row=row;
         $$->symp->type->column=col;
         $$->symp->size=(row*col*size_of_double)+8;
       }
     string res=$$->getSymp()->name;
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit (ADD, res, name1, name2);
   }
   else cout << "Type Error"<< endl;
 }
 | additive_expression '-' multiplicative_expression {
   if (typecheck($1->symp, $3->symp))                          // Handling Type Check
   {
     $$ = new Expression();

           int row,col;

              if ($1->symp->type->cat!=_MATRIX && $3->symp->type->cat==_MATRIX)
             {
               symbolType *t=new symbolType($3->symp->type->cat,NULL,0);
               row=$3->symp->type->row;
               col=$3->symp->type->column;
               $$->symp = gentemp(t,"Mat_temp");
             }
             else if ($1->symp->type->cat==_MATRIX && $3->symp->type->cat!=_MATRIX)
             {
               symbolType *t=new symbolType($1->symp->type->cat,NULL,0);
               row=$1->symp->type->row;
               col=$1->symp->type->column;
               $$->symp = gentemp(t,"Mat_temp");
             }
             else
                  $$->setSymp(gentemp(($1->getSymp())->type->cat));

             if ($1->symp->type->cat==_MATRIX && $3->symp->type->cat!=_MATRIX)
             {
               $$->symp->type->row=row;
               $$->symp->type->column=col;
                 $$->symp->size=(row*col*size_of_double)+8;
             }
             else if($1->symp->type->cat!=_MATRIX && $3->symp->type->cat==_MATRIX)
             {
               $$->symp->type->row=row;
               $$->symp->type->column=col;
                 $$->symp->size=(row*col*size_of_double)+8;
             }
           string res=$$->getSymp()->name;
           string name1=$1->getSymp()->name;
           string name2=$3->getSymp()->name;
     emit (SUB, res, name1, name2);
   }
   else cout << "Type Error"<< endl;
 }
 ;


 /*For an expression to support shift operation on itself it should be of type integer
 which is checked in the following code. Else Type Error is generated*/

shift_expression
 : additive_expression {$$ = $1;}
 | shift_expression LEFT_SHIFT additive_expression
 {
   typeEnum intType=_INT;
   typeEnum cat=$3->symp->type->cat;
   if (cat == intType)                                             // Checking if additive_expression is of type integer
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
 | shift_expression RIGHT_SHIFT additive_expression               // Checking if additive_expression is of type integer
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

                                 /*
                                   In the following section truelist and falselist are generated which are backpatched later
                                   ie the goto labels in the quad emissions are kept empty as indicated in following comments.
                                   Before comparing two expressions(relational_expression,shift_expression) their type compatibility is also checked
                                 */

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
     $$->setIsBool(true);                                             // relational_expression is of type conditional which is set here.

     $$->truelist = makelist (nextinstr());
     $$->falselist = makelist (nextinstr()+1);
     string nullstring="";
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit(LT, nullstring, name1, name2);                             // emit if name1<name2 goto ___
     emit (GOTOOP, nullstring);                                      // emit goto ___
   }
   else cout << "Type Error"<< endl;
 }
 | relational_expression '>' shift_expression
 {
   if (typecheck ($1->symp, $3->symp) )
   {
     // New bool
     $$ = new Expression();
     $$->setIsBool(true);                                            // relational_expression is of type conditional which is set here.

     $$->truelist = makelist (nextinstr());
     $$->falselist = makelist (nextinstr()+1);
     string nullstring="";
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit(GreaterThan, nullstring, name1, name2);                  // emit if name1>name2 goto ___
     emit (GOTOOP, nullstring);                                    // emit goto ___

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
     emit(LE, nullstring, name1, name2);                              // emit if name1<=name2 goto ___
     emit (GOTOOP, nullstring);                                      // emit goto ___
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
     emit(GREATERTHANEQ, nullstring, name1, name2);                   // emit if name1<=name2 goto ___
     emit (GOTOOP, nullstring);                                       // emit goto ___
   }
   else cout << "Type Error"<< endl;
 }
 ;

                           /*
                             In the following section truelist and falselist are generated which are backpatched later
                             ie the goto labels in the quad emissions are kept empty as indicated in following comments.
                             Before comparing two expressions(equality_expression,relational_expression) their type compatibility is also checked
                           */
equality_expression
 : relational_expression {$$ = $1;}
 | equality_expression EQUALITY relational_expression {
   if (typecheck ($1->symp, $3->symp) )
   {

     convertfrombool ($1);
     convertfrombool ($3);

     $$ = new Expression();
     $$->setIsBool(true);                                                // equality_expression is of type conditional which is set here for future use.

     $$->truelist = makelist (nextinstr());
     $$->falselist = makelist (nextinstr()+1);
     string nullstring="";
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit(EQOP, nullstring, name1, name2);                               // emit if name1==name2 goto ___
     emit (GOTOOP, nullstring);                                          // goto ___

   }
   else cout << "Type Error"<< endl;
 }
 | equality_expression NOT_EQUAL_TO relational_expression {
   if (typecheck ($1->symp, $3->symp) ) {

     convertfrombool ($1);
     convertfrombool ($3);

     $$ = new Expression();
     $$->setIsBool(true);

     $$->truelist = makelist (nextinstr());
     $$->falselist = makelist (nextinstr()+1);
     string nullstring="";
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit(NEOP, name1, name2);                                           // emit if name1!=name2 goto ___
     emit (GOTOOP, nullstring);                                          // goto ___
 ;
   }
   else cout << "Type Error"<< endl;
 }
 ;


                                         /*
                                           Type compatibility is also checked before quad emission.
                                         */
AND_expression
 : equality_expression {$$ = $1;}
 | AND_expression '&' equality_expression {
   if (typecheck ($1->symp, $3->symp) )
   {
     $$ = new Expression();
     $$->setIsBool(false);                                              // AND_expression is not a conditional expression

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

     convertfrombool ($1,$3);
      $$ = new Expression();


     $$->setIsBool(false);                                        // exclusive_OR_expression is not a conditional expression
     $$->setSymp(gentemp (_INT));
     string name=$$->getSymp()->name;
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit (XOR, name, name1, name2);
   }
   else cout << "Type Error"<< endl;
 }
 ;

                                 /*
                                   Type compatibility is also checked before quad emission.
                                 */

inclusive_OR_expression
 : exclusive_OR_expression {$$ = $1;}
 | inclusive_OR_expression '|' exclusive_OR_expression {
   if (typecheck ($1->symp, $3->symp) )

   {


     convertfrombool ($1,$3);
     $$ = new Expression();

     $$->setIsBool(false);                                         // inclusive_OR_expression is not a conditional expression
     $$->setSymp(gentemp (_INT));
     string name=$$->getSymp()->name;
     string name1=$1->getSymp()->name;
     string name2=$3->getSymp()->name;
     emit (INCLUSIVEOR, name, name1, name2);

   }
   else cout << "Type Error"<< endl;
 }
 ;
 /*
   Type compatibility is also checked before quad emission.
 */

logical_AND_expression
 : inclusive_OR_expression
 {
   $$ = $1;                                                     // copy all the Attributes including truelist and falselist
 }
 | logical_AND_expression N AND_AND M inclusive_OR_expression
 {
   covertToBoolean($5);


   backpatch($2->nextlist, nextinstr());                        // backpatching
   covertToBoolean($1);
   $$ = new Expression();

   $$->setIsBool(true);                                        // inclusive_OR_expression is not a conditional expression

   backpatch($1->getTruelist(), $4);                           // backpatching
   $$->setTruelist($5->getTruelist());                         // if B->B1 && B2 then B.truelist=B2.truelist
                                                               // And B.falselist=merge(B1.falselist,B2.falselist) which is set here.
   $$->setFalselist (merge ($1->falselist, $5->falselist));
 }
 ;

logical_OR_expression
 : logical_AND_expression {$$ = $1;                        // copy all the Attributes including truelist and falselist
                           }
 | logical_OR_expression N OR_OR M logical_AND_expression {
   covertToBoolean($5);

   // N to convert $1 to bool
   backpatch($2->nextlist, nextinstr());
   covertToBoolean($1);
   $$ = new Expression();

   $$->setIsBool(true);                                        // inclusive_OR_expression is not a conditional expression

   backpatch ($$->getFalselist(), $4);
   $$->setTruelist( merge ($1->truelist, $5->truelist));     // if B->B1 || B2 then B.truelist=merge(B1.truelist,B2.truelist)
                                                               // And B.falselist=meger(B2.falselist) which is set here.
   $$->setFalselist($5->falselist);
 }
 ;

M 	: %empty{	                                                                  // Stores the address of the nextinstruction to be used in backpatching
   $$ = nextinstr();
 };

N 	: %empty { 	                                                                // Prevents fall by emitting a GOTO

   $$  = new Expression();
   $$->nextlist = makelist(nextinstr());                                      // Nextlist points to the next instruction.
   string nullstring="";
   emit (GOTOOP,nullstring);

 }

conditional_expression
 : logical_OR_expression {$$ = $1;}
 | logical_OR_expression N '?' M expression N ':' M conditional_expression
 {
             /*Ternary operator is handled here*/

   $$->setSymp( gentemp());
   ($$->getSymp())->update($5->getSymp()->type);
   string res=$$->getSymp()->name;
   string arg=$9->getSymp()->name;









   emit(EQUAL, res, arg);
   li l = makelist(nextinstr());
   string nullstring="";
   emit (GOTOOP,nullstring);                           // emit goto_______
                                                       // the empty lable is to be backpatched later suitably

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
 | unary_expression assignment_operator assignment_expression {
   typeEnum category=$1->getCat();

                                               /*
                                               The case where the LHS of the assignment_expression is a matrix (within it,
                                               whether a transpose operation is being handled) or pointer is dealt with separately
                                               */

   if (category==_MATRIX)
   {
     cout<<" name name "<<$1->symp->name<<" "<<" "<<$1->loc->name<<" "<<$3->symp->name<<endl;
      $3->symp = conv($3->symp, $1->type->cat);
       /*if (transRUN==false)*/
           emit(ARRL, $1->symp->name, $1->loc->name, $3->symp->name);
       /*else
           {
                 emit(EQUAL, $1->symp->name,$3->symp->name);
                 transRUN=false;
           }*/
   }

   else if(category==PTR)
   {

     emit(PTRL, $1->symp->name, $3->symp->name);

   }
   else
   {
     //cout<<" name name "<<$1->symp->name<<" "<<$3->symp->name<<endl;
     $3->symp = conv($3->symp, $1->symp->type->cat);
     emit(EQUAL, $1->symp->name, $3->symp->name);
   }
   $$ = $3;

 }
 ;
                               /*The different assignment operators such as =,/= etc
                               are assigned to assignment_operator here*/

assignment_operator
 : MULT_EQUAL |'='| OR_EQUAL| LEFT_SHIFT_EQUAL  | DIV_EQUAL | MOD_EQUAL | ADD_EQUAL  | AND_EQUAL | SUB_EQUAL | RIGHT_SHIFT_EQUAL| XOR_EQUAL

 ;

expression
 : assignment_expression {
   $$ = $1;}
 | expression ',' assignment_expression

 ;

constant_expression : conditional_expression;


                                           // declaration of functions and variables are dealt with here onwards

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

   if($1->type->cat==_MATRIX)
 {


   $1->mat_init_col_list=$3->mat_init_col_list;
   for(int ii=0;ii<$1->mat_init_col_list.size();ii++)
   {
     for(int jj=0;jj<$1->mat_init_col_list[ii].size();jj++)
     {
       //cout << "( " << $1->mat_init_col_list[ii][jj].first <<","<<$1->mat_init_col_list[ii][jj].second <<") | ";
       emit(INIT_MAT,$1->name,(ii*$1->mat_init_col_list[ii].size()+jj)*8,$1->mat_init_col_list[ii][jj].first);
     }

   }
 }

    if ($3->init!="") $1->initialize($3->init);
   if ($1->type->cat!=_MATRIX)
    emit (EQUAL, $1->name, $3->name);


 }
 ;

                                       // The variable type stores the latest type of identifier declared.
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
                               /*
                                   While declaring a matrix the row and column dimensions are stored
                                   in the row column attribute field
                               */
         int x = atoi($3->symp->init.c_str());
         symbolType* s = new symbolType(_MATRIX, $1->type, x);
               s->row=x;
               s->column=atoi($6->symp->init.c_str());
         int y = calculateSizeOfType(s);
         $$ = $1->update(s);

     }

 | direct_declarator '['   assignment_expression ']' | direct_declarator '['  '*' ']'
 | direct_declarator '(' CST parameter_type_list ')'
 {
                               /*
                                     Dealing with a Function declaration
                               */
   string funcName=$1->getName();
   table->setTableName(funcName);                          // set the name of the table to the function name
   typeEnum returnCat=$1->getType()->cat;                 // get the return type of the function from the non-terminal direct_declarator
   if (returnCat !=_VOID)                                 // if the function is of return type non-void
   {
     symb *s = table->lookup("retVal");
     s->update($1->type);                                 // update the return type  of the function in its entry in the symbol table
   }

   $1 = $1->linkst(table);                                // set the nest link of this new function to its own separate symbol table

   table->setParent(globalSymbolTable);                   // set parent of the new function
   changeTable (globalSymbolTable);				               // return to the global symbol table

   currentSymbol = $$;
 }
 | direct_declarator '(' identifier_list ')' 	| direct_declarator '(' CST ')' {
   string funcName=$1->getName();
   table->setTableName(funcName);			                  // set the name of the table to the function name
   typeEnum returnCat=$1->getType()->cat;                // get the return type of the function from the non-terminal direct_declarator
   if (returnCat !=_VOID) {
     symb *s = table->lookup("retVal");                  // update the return type  of the function in its entry in the symbol table
     s->update($1->type);
   }

   $1 = $1->linkst(table);		                           // set the nest link of this new function to its own separate symbol table

   table->setParent(globalSymbolTable);
   changeTable (globalSymbolTable);				             // return to the global symbol table

   currentSymbol = $$;
 }
 ;

CST : %empty {                                                                 // Used for switching function table
   if (currentSymbol->nest==NULL) changeTable(new symbolTable(""));	         // create a new table if it doesnt exist.
   else {
     changeTable (currentSymbol ->nest);						                           // Function symbol table already exists
     string tableName=table->getTableName();
     emit (FUNC,tableName);                                                  // emit labels corresponding to the function names.
   }
 }
 ;

pointer
 : '*' {$$ = new symbolType(PTR);}

 | '*' pointer {$$ = new symbolType(PTR, $2);}


 ;


                          /*
                                   Dealing with parameters declaration for functions.
                         */

parameter_type_list
 : parameter_list;

parameter_list
 : parameter_declaration | parameter_list ',' parameter_declaration
 ;

parameter_declaration
 : declaration_specifiers declarator {
   $2->category = "param";
 }
 | declaration_specifiers

 ;
                                               // List of identifiers

identifier_list
 : IDENTIFIER
 | identifier_list ',' IDENTIFIER

 ;



                                    /* The following parsing rules come into play while declaring a Matrix*/

initializer_row_list:
               initializer_row
               { $$=$1;    }
           |   initializer_row_list ';' initializer_row
               {   rowison=false;
                  // $$=new symb();
                  traverse2($$->mat_init_row_list,it)
                   cout<<"row 1"<< it->first<<" "<<it->second<<endl;

                   traverse2($3->mat_init_row_list,it)
                    cout<<"row 3"<< it->first<<" "<<it->second<<endl;

                   $$->mat_init_col_list.push_back($$->mat_init_row_list);
                   $$->mat_init_col_list.push_back($3->mat_init_row_list);

                   traverse2($$->mat_init_row_list,it)
                    cout<<"row 2"<< it->first<<" "<<it->second<<endl;


 $$->mat_init.append(";");
 $$->mat_init.append($3->mat_init);}
       ;
initializer_row
 : initializer
       {// $$=$1;
         pair <string , int > p_tmp ($1->name,0);
		$$->row_maj_index=0;
		$$->mat_init_row_list.push_back(p_tmp);
       }
 | designation initializer
       {
           $$=$2;
       }
 | initializer_row ',' initializer
       {

          // $$=$1;
           $$->row_maj_index++;
 pair <string , int > p_tmp ($3->name,$$->row_maj_index);
 $$->mat_init_row_list.push_back(p_tmp);



 $$->mat_init.append(",");
 $$->mat_init.append($3->mat_init);
       }

 ;
initializer
 : assignment_expression {
   $$ = $1->symp;
 }
 | '{' empty_token initializer_row_list '}'
       {
                                   /* the initial value string of the matrix is parsed to assign proper dimensions to the temporary*/

             $$=$3;
             /*string initial="{"+$3->init+"}";
            // $$->init=initial;
             string rowS=$3->init;

              int ro=1,col=1;
              bool notfound=true;
             for(int i=0;i<rowS.size();i++)
               {
                   //cout<<rowS[i]<<endl;
                   if (rowS[i]==','&& notfound)
                       col++;
                   else if(rowS[i]==';')
                       {ro=ro+1;notfound=false;}
                   else    ;
               }
            //symb* t=gentemp(_DOUBLE, initial);


               symbolType *t=new symbolType(_MATRIX,NULL,0);
               t->row=ro;                                                // assign the dimensions of temporary generated
               t->column=col;

               symb *t1= gentemp(t,$$->init,true);
               $$->name=t1->name;;*/
       }

 ;

empty_token:    %empty  {
                 rowison=false;
               }




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

labeled_statement
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
                                         /* deals with the if statements*/
selection_statement
 :
 IF '(' expression  ')' M statement N ELSE M statement {
   /*cout<<" HERE\n";*/
  backpatch ($7->nextlist, nextinstr());                          // backpatching
  covertToBoolean($3);
      $$=new statement();
  backpatch ($3->truelist, $5);                                   // backpatching
  backpatch ($3->falselist, $9);                                 // backpatching
  li tmp= merge ($6->nextlist, $7->nextlist);
  li tmp2=merge (tmp, $10->nextlist);
  $$->setNextlist(tmp2);
 }
 |
 IF '(' expression ')' M statement  {
  /*li n1=$4->nextlist;
  backpatch (n1, nextinstr());                                      // backpatching*/
 /*cout<<"IAM HERE\n";*/
  covertToBoolean($3);


  $$ = new statement();
  li expressionList=$3->truelist;
  backpatch (expressionList, $5);
  backpatch($3->falselist,nextinstr());

  $$->setNextlist(merge ($3->falselist, $6->nextlist));
  /*,$7->nextlist*/

 }
 | SWITCH '(' expression ')' statement                                /* Skipped */

 ;
 iteration_statement:
                                         /*  Dealing with iterations( for,while,do-while). */
                                         WHILE M '(' expression ')' M statement {
                                          $$ = new statement();
                                          covertToBoolean($4);
                                          li statementList=$7->nextlist;
                                          backpatch(statementList, $2);
                                          li expressionList=$4->getTruelist();
                                          backpatch(expressionList, $6);
                                          backpatch($4->getFalselist(),nextinstr());
                                          $$->nextlist = $4->getFalselist();

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
                                          backpatch($5->getFalselist(),nextinstr()+1);
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
                                          backpatch($5->getFalselist(),nextinstr()+1);
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

                                                         /* External Definition Phase */

translation_unit
 : external_declaration | translation_unit external_declaration	;

external_declaration
 : function_definition | declaration ;

function_definition
 : declaration_specifiers declarator declaration_list CST compound_statement {

 }
 | declaration_specifiers declarator CST compound_statement
 {
     emit (FUNCEND, table->tableName);
     table->parent = globalSymbolTable;
     changeTable (globalSymbolTable);
 }
 ;
declaration_list
 : declaration| declaration_list declaration	;

%%

void yyerror(const char *s) {
 printf ("ERROR: %s",s);
}
