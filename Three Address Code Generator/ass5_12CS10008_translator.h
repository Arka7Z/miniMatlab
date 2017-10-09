#ifndef TRANSLATE
#define TRANSLATE
#include <bits/stdc++.h>
#include <iostream>

 #define size_of_char 1
 #define size_of_int 4
 #define size_of_double 8
 #define size_of_pointer 4
 #define traverse(container, it) for(it = container.begin(); it != container.end(); ++it)
 #define traverse2(container, it) for(typeof (container.begin()) it = container.begin(); it != container.end(); ++it)
 #define SSTR(x) static_cast<std::ostringstream& >((std::ostringstream() << std::dec << x)).str()
 #define debug(x) (x)
extern char * yytext;
extern int yyparse();


using namespace std;
typedef list< int > li;
// /********* Forward Declarations ************/
//
class symb; // Entry in a symbol table
class symbolTable; // Symbol Table
class quad; // Entry in quad array
class quads; // All Quads
class symbolType; // Type of a symbol in symbol table

/************** Enum types *****************/

enum opTypeEnum {
        EQUAL,
        // Relational Operators
        LT,
        GreaterThan,
        LE,
        GREATERTHANEQ,
        EQOP,
        NEOP,
        GOTOOP,
        _RETURN,
        // Arithmatic Operators
        ADD,
        SUB,
        MULT,
        DIVIDE,
        RIGHTSHIFT,
        LEFTSHIFT,
        MODULUS,
        // UnaryExpr Operators
        UNARYMINUS,
        UPLUS,
        ADDRESS,
        RIGHT_POINTER,
        BINARYNOT,
        LNOT,
        TRANSOP,
        // Bit Operators
        BINARYAND,
        XOR,
        INCLUSIVEOR,
        // PTR Assign
        PTRL,
        PTRR,
        // ARR Assign
        ARRR,
        ARRL,
        // Function call
        PARAM,
        CALL,
        LABEL
};
enum typeEnum { // Type enumeration
        _VOID,
        _CHAR,
        _INT,
        _DOUBLE,
        PTR,
        ARR,
        FUNC,
        _MATRIX
};

/********** Class Declarations *************/

class symbolType { // Type of an element in symbol table
        public:
                symbolType(typeEnum cat, symbolType * ptr = NULL, int width = 1);
        typeEnum cat;
        int width; // Size of array
        int column, row;
        symbolType * ptr; // Array -> array of ptr type; pointer-> pointer to ptr type

        friend ostream & operator << (ostream & ,const symbolType);
        int getWidth();
        int getColumn();
        int getRow();
        symbolType * getPtr();
        typeEnum getCat();
        void setWidth(int width);
        void setColumn(int column);
        void setRow(int row);
        void setCat(typeEnum cat);
        void setPtr(symbolType* ptr);
};

class symb { // Row in a Symbol Table
        public:

        symbolType * type; // Type of Symbol
        string init; // Symbol initialisation
        string category; // local, temp or global
        int size; // Size of the type of symbol
        int row, column;
        int offset; // Offset of symbol computed at the end
        symbolTable * nest; // Pointer to nested symbol table
          string name; // Name of symbol
        symb * initialise(string initialVal);
        symb * initialize(string initialVal);
        symb(string, typeEnum type_e = _INT, symbolType * ptr = NULL, int width = 0);
        symb * update(symbolType * temp); // Update using type object and nested table pointer
        symb * update(typeEnum type_e); // Update using raw type and nested table pointer

        friend ostream & operator << (ostream & ,
                const symb * );
        symb * linkst(symbolTable * t);
        string getName();
        string getInit();
        string getCategory();
        int getOffset();
        symbolTable * getNest();
        symbolType * getType();
        void setName(string name);
        void setInit(string init);
        void setCategory(string category);
        void setOffset(int offset);
        void setNest(symbolTable * nest);
};

class symbolTable { // Symbol Table
        public:
                string tableName; // Name of Table
        int tempCount; // Count of temporary variables
        list <symb> table; // The table of symbols
        symbolTable* parent;

        symbolTable(string name = "");
        symb * lookup(string name); // Lookup for a symbol in symbol table
        void print(int all = 0); // Print the symbol table
        void computeOffsets(); // Compute offset of the whole symbol table recursively
        //
        string getTableName();
        int getTempCount();
        list<symb> getTable();
        symbolTable * getParent();
        void setTableName(string name);
        void setTempCount(int count);
        void setTable(list<symb> table);
        void setParent(symbolTable* parent);
};

class quad { // Individual Quad
        public:

        string argument1; // Argument 1
        string argument2; // Argument 2
        string result; // Result
        opTypeEnum op; // Operator


        void update(int address); // Used for backpatching address
        void print(); // Print Quads
        quad(string result, int argument1, opTypeEnum op = EQUAL, string argument2 = "");
        quad(string result, string argument1, opTypeEnum op = EQUAL, string argument2 = "");
        // Getter and Setter Methods
        opTypeEnum getOpCode();
        string getResult();
        string getArgument1();
        string getArgument2();
        void  setOpCode(opTypeEnum opcode);
        void setResult(string Result);
        void setArgument1(string argument1);
        void setArgument2(string argument2);
};

class quads { // Quad Array
        public:
                vector<quad> array;; // Vector of quads

        quads()
        {
                array.reserve(300);
        }
        void print(); // Print all the quads
        void printtab(); // Print quads in tabular form
        vector<quad> getArray();
        void setArray(vector<quad> v);
};

// class Singleton { // Global Symbol Table is Singleton Object
//         public:
//                 static Singleton * GetInstance();
//         private:
//                 Singleton();
//         static Singleton * pointerToSingleton; // singleton instance
// };

/*********** Function Declarations *********/
void emit(opTypeEnum op, string result, int argument1, string argument2 = "");
symb * gentemp(typeEnum t = _INT, string init = ""); // Generate a temporary variable and insert it in symbol table
symb * gentemp(symbolType * t, string init = "", bool decl = false); // Generate a temporary variable and insert it in symbol table
li merge(li & , li &); // Merge two lists
li merge(li &, li &, li&);
void backpatch(li List , int instr);
void emit(opTypeEnum opL, string result, string argument1 = "", string argument2 = "");


li makelist(int); // Make a new list contaninig an integer


string int2string(int); // Converts a number to string mainly used for storing numbers
string returnTypeString(const symbolType * ); // For printing type structure
string opCodeToString(int);
int calculateSizeOfType(symbolType * symp); // Calculate size of any type
symb * conv(symb * symp, typeEnum type_e); // Convert symbol to different type

bool typecheck(symbolType * s1, symbolType * s2); // Check if the type objects are equivalent

int nextinstr(); // Returns the address of the next instruction

bool typecheck(symb * & s1, symb * & s2); // Checks if two symbbol table entries have same type

void changeTable(symbolTable * newtable);

/*** Global variables declared in cxx file****/

extern quads quadArray; // Quads
extern symbolTable * globalSymbolTable; // Global Symbol Table
extern symbolTable * table; // Current Symbol Table
extern symb * currentSymbol; // Pointer to just encountered symbol

/** Attributes/Global for Boolean Expression***/

class Expression {
public:
        bool isbool; // Boolean variable that stores if the expression is bool

        // Valid for non-bool type
        symb * symp; // Pointer to the symbol table entry

        // Valid for bool type
        li truelist; // Truelist valid for boolean
        li falselist; // Falselist valid for boolean expressions

        // Valid for statement expression
        li nextlist;
        Expression()
        {
          ;
        }
        symb* getSymp();
        li getTruelist();
        li getFalselist();
        li getNextlist();
        void setIsBool(bool flag);
        void setSymp(symb* symp);
        void setTruelist(li truelist);
        void setFalselist(li falselist);
        void setNextlist(li Nextlist);

      }
        ;

class statement {                      // Nextlist for statement
public:
        list < int > nextlist;
      statement()
    {
      ;
    }
    void setNextlist(li nextlist);
    li getNextlist();
  };

class UnaryExpr
{
public:
        typeEnum cat;
        symb * loc; // Temporary used for computing array address
        symb * symp; // Pointer to symbol table
        symbolType * type; // type of the subarray generated
        UnaryExpr()
        {
          ;
        }
        symb* getSymp();
        symb* getLoc();
        typeEnum getCat();
        symbolType* getType();
        void setSymp(symb* symp);
        void setLoc(symb* loc);
        void setCat(typeEnum cat);
        void setType(symbolType* type);
};

// Utility functions

Expression * convertfrombool(Expression * ); // convert bool to expression
Expression * convertfrombool(Expression * e,Expression* e1);
template < typename T > string tostr(const T & t) {
      return (SSTR(t));}
bool isFalse();
void setUnaryOp(char& a,char b);

Expression * covertToBoolean(Expression * ); // convert any expression to bool


#endif
