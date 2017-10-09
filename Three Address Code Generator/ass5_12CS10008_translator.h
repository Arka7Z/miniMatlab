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

// /********* Forward Declarations ************/
//
// class sym; // Entry in a symbol table
// class symbolTable; // Symbol Table
// class quad; // Entry in quad array
// class quads; // All Quads
// class symbolType; // Type of a symbol in symbol table

/************** Enum types *****************/

enum optype {
        EQUAL,
        // Relational Operators
        LT,
        GreaterThan,
        LE,
        GE,
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
        // Unary Operators
        UMINUS,
        UPLUS,
        ADDRESS,
        RIGHT_POINTER,
        BNOT,
        LNOT,
        TRANSOP,
        // Bit Operators
        BINARYAND,
        XOR,
        INOR,
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

        friend ostream & operator << (ostream & ,
                const symbolType);
};

class sym { // Row in a Symbol Table
        public:
                string name; // Name of symbol
        symbolType * type; // Type of Symbol
        string init; // Symbol initialisation
        string category; // local, temp or global
        int size; // Size of the type of symbol
        int row, column;
        int offset; // Offset of symbol computed at the end
        symbolTable * nest; // Pointer to nested symbol table

        sym(string, typeEnum t = _INT, symbolType * ptr = NULL, int width = 0);
        sym * update(symbolType * t); // Update using type object and nested table pointer
        sym * update(typeEnum t); // Update using raw type and nested table pointer
        sym * initialize(string);
        friend ostream & operator << (ostream & ,
                const sym * );
        sym * linkst(symbolTable * t);
};

class symbolTable { // Symbol Table
        public:
                string tableName; // Name of Table
        int tempCount; // Count of temporary variables
        list <sym> table; // The table of symbols
        symbolTable * parent;

        symbolTable(string name = "");
        sym * lookup(string name); // Lookup for a symbol in symbol table
        void print(int all = 0); // Print the symbol table
        void computeOffsets(); // Compute offset of the whole symbol table recursively
};

class quad { // Individual Quad
        public:
                optype op; // Operator
        string result; // Result
        string arg1; // Argument 1
        string arg2; // Argument 2

        void print(); // Print Quads
        void update(int addr); // Used for backpatching address
        quad(string result, string arg1, optype op = EQUAL, string arg2 = "");
        quad(string result, int arg1, optype op = EQUAL, string arg2 = "");
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
};

class Singleton { // Global Symbol Table is Singleton Object
        public:
                static Singleton * GetInstance();
        private:
                Singleton();
        static Singleton * pointerToSingleton; // singleton instance
};

/*********** Function Declarations *********/

sym * gentemp(typeEnum t = _INT, string init = ""); // Generate a temporary variable and insert it in symbol table
sym * gentemp(symbolType * t, string init = "", bool decl = false); // Generate a temporary variable and insert it in symbol table

void backpatch(list < int > , int);
void emit(optype opL, string result, string arg1 = "", string arg2 = "");
void emit(optype op, string result, int arg1, string arg2 = "");

list < int > makelist(int); // Make a new list contaninig an integer
list < int > merge(list < int > & , list < int > & ); // Merge two lists

int sizeoftype(symbolType * ); // Calculate size of any type
string returnTypeString(const symbolType * ); // For printing type structure
string opCodeToString(int);

sym * conv(sym * , typeEnum); // Convert symbol to different type
bool typecheck(sym * & s1, sym * & s2); // Checks if two symbbol table entries have same type
bool typecheck(symbolType * s1, symbolType * s2); // Check if the type objects are equivalent

int nextinstr(); // Returns the address of the next instruction
string int2string(int); // Converts a number to string mainly used for storing numbers

void changeTable(symbolTable * newtable);

/*** Global variables declared in cxx file****/

extern symbolTable * table; // Current Symbol Table
extern symbolTable * globalSymbolTable; // Global Symbol Table
extern quads quadArray; // Quads
extern sym * currentSymbol; // Pointer to just encountered symbol

/** Attributes/Global for Boolean Expression***/

struct expr {
        bool isbool; // Boolean variable that stores if the expression is bool

        // Valid for non-bool type
        sym * symp; // Pointer to the symbol table entry

        // Valid for bool type
        list < int > truelist; // Truelist valid for boolean
        list < int > falselist; // Falselist valid for boolean expressions

        // Valid for statement expression
        list < int > nextlist;
};

struct statement {
        list < int > nextlist; // Nextlist for statement
};

struct unary {
        typeEnum cat;
        sym * loc; // Temporary used for computing array address
        sym * symp; // Pointer to symbol table
        symbolType * type; // type of the subarray generated
};

// Utility functions
template < typename T > string tostr(const T & t) {
        ostringstream outstream;
        outstream << t;
        return outstream.str();
}

expr * convert2bool(expr * ); // convert any expression to bool
expr * convertfrombool(expr * ); // convert bool to expression

#endif
