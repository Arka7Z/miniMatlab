#ifndef TRANSLATE
#define TRANSLATE
#include <bits/stdc++.h>
#include <iostream>


// Size declaration of the types

 #define size_of_char 1
 #define size_of_int 4
 #define size_of_double 8
 #define size_of_pointer 4

 // macros to implement repetitive tasks such as  traversing any STL container etc

 #define traverse(container, it) for(it = container.begin(); it != container.end(); ++it)
 #define traverse2(container, it) for(typeof (container.begin()) it = container.begin(); it != container.end(); ++it)
 #define SSTR(x) static_cast<std::ostringstream& >((std::ostringstream() << std::dec << x)).str()
 #define debug(x) (x)

extern char * yytext;
extern int yyparse();


using namespace std;
typedef list< int > li;

class symb;                                           // Entry in a symbol table
class symbolTable;                                    // Symbol Table
class quad;                                           // Individual Quads
class quads;                                          // Array Quads
class symbolType;                                     // Type of a symbol in symbol table

// Enums for opcode and type(int,double etc)

enum opTypeEnum {                                      //OpCodes for the quads
        EQUAL, EQUALSTR, EQUALCHAR,

        // Relational Operators
        LT,
        GreaterThan,
        LE,
        GREATERTHANEQ,
        EQOP,
        NEOP,
        GOTOOP,
        _RETURN,

        // Arithmetic Operators
        ADD,
        SUB,
        MULT,
        DIVIDE,
        RIGHTSHIFT,
        LEFTSHIFT,
        MODULUS,

        // Unary Operators
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

        // Pointer Assignment
        PTRL,
        PTRR,

        // Matrix Assignment
        ARRR,
        ARRL,

        // Function call
        PARAM,
        CALL,
        FUNC,
        FUNCEND
};
enum typeEnum {                                           // Type enumeration
        _VOID,
        _CHAR,
        _INT,
        _DOUBLE,
        PTR,
        ARR,
        _MATRIX
};

//Class Declarations

class symbolType {                                                              // Type and other info such as dimensions of a symbol
        public:

        typeEnum cat;                                                           // category of the symbol as in int,double,matrix etc.
        int width;                                                              // Size of the Matrix
        int column, row;                                                        // Dimensions of the matrix
        symbolType * ptr;                                                       //  Nested Pointer

        symbolType(typeEnum cat, symbolType * ptr = NULL, int width = 1);       // Constructor with default arguments
        friend ostream & operator << (ostream & ,const symbolType);

        //Getter Setter Methods
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

class symb {                                                                    // Row in a Symbol Table ie an entry in the symbol table

  public:
        symbolType * type;                                                      // Type of the symbol
        string init;                                                            // Initial Value stored as string
        string category;                                                        // local, temp or global
        int size;                                                               // Size of the  symbol
        int row, column;
        int offset;                                                             // offset in the symbol table
        symbolTable * nest;                                                     // Pointer to nested symbol table which comes into use during function calls
        string name;                                                            // Name of the symbol

        symb * initialise(string initialVal);                                   // Initialize with the initial value
        symb * initialize(string initialVal);                                   // dummy function as above
        symb(string, typeEnum type_e = _INT, symbolType * ptr = NULL, int width = 0);     // Constructor
        symb * update(symbolType * temp);                                       // Updates symbol using a type object and nested table pointer such as during declartion of variables
        symb * update(typeEnum type_e);                                         // Updates symbol such as during declartion of variables

        friend ostream & operator << (ostream & ,const symb * );
        symb * linkst(symbolTable * t);                                         // Sets nesed symbol table during funciton calculateSizeOfType

        //Getter Setter Methods
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

class symbolTable {                                                             // Class to implement the symbol table
    public:
        string tableName;                                                       // Name of the table such as Global, main or a particular function
        int tempCount;                                                          // Number of tempory variables used in this scope
        list <symb> table;                                                      // Symbol table implemented as list of symbols
        symbolTable* parent;                                                    // Parent(caller) of a function
        map<string, int> ar;		// Activation Record

        symbolTable(string name = "");                                          // Constructor
        symb * lookup(string name);                                             // A method to lookup an id (given its name or lexeme) in the Symbol Table. If the
                                                                                // id exists, the entry is returned, otherwise a new entry is created.
        void print(int all = 0);                                                // Print the symbol table
        void computeOffsets();                                                  // Compute offset of each entry in the symbol table after the table is constructed

        //Getter Setter Methods for the above data members
        string getTableName();
        int getTempCount();
        list<symb> getTable();
        symbolTable * getParent();
        void setTableName(string name);
        void setTempCount(int count);
        void setTable(list<symb> table);
        void setParent(symbolTable* parent);
};

class quad {                                                                    // Individual Quads
        public:

        string argument1;                                                       // Argument 1
        string argument2;                                                       // Argument 2
        string result;                                                          // Result
        opTypeEnum op;                                                          // Opcode


        void update(int address);                                               // Function to update the address of quads during backpatching
        void print();                                                           // Print the quad

        //Constructors to support the different quad emissions
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

class quads {                                                                   // Class to implement quad array
        public:
                vector<quad> array;;                                            // Quad array

        quads()
        {
                array.reserve(270);                                             // Resereve size for at leat 270 quads during consruction
        }
        void print();                                                           // Print all the quads in the quad array
        void printtab();                                                        // Print quads in the form of a table
        //Getter setter methods
        vector<quad> getArray();
        void setArray(vector<quad> v);
};



//  Function declarations
void emit(opTypeEnum op, string result, int argument1, string argument2 = "");  // Function to emit(generate) quads
symb * gentemp(typeEnum t = _INT, string init = "");                            // Generate a temporary variable and insert it in the  current symbol table
symb * gentemp(symbolType * t, string init = "", bool decl = false);            // Generate a temporary variable and insert it in the current symbol table
li merge(li & , li &);                                                          // Merge two lists and return the merged list
li merge(li &, li &, li&);                                                      // Merge two lists and return the merged list
void backpatch(li List , int instr);                                            // backpatch list List with address instr
void emit(opTypeEnum opL, string result, string argument1 = "", string argument2 = ""); //Function to emit quads


li makelist(int);                                                               // Make a new list contaninig a single entry and  return it


string int2string(int);                                                         // Converts an integer to string
string returnTypeString(const symbolType * );                                   // For printIntng type structure
string opCodeToString(int);                                                     // Returns the operator string for opcodes such as "+","&","param"
int calculateSizeOfType(symbolType * symp);                                     // Returns the size of a type such as char,int,double
symb * conv(symb * symp, typeEnum type_e);                                      // To support type casting such as int2double

bool typecheck(symbolType * s1, symbolType * s2);                               // Check if the types  are equivalent
int nextinstr();                                                                // Returns the address of the next instruction which is used in backpatching
bool typecheck(symb * & s1, symb * & s2);                                       // Checks if the types are equivalent
void changeTable(symbolTable * newtable);                                       // Change current symbol table during a function call

// Global variables used

extern quads quadArray;                                                         // Quad Array
extern symbolTable * globalSymbolTable;                                         // Global Symbol Table
extern symbolTable * table;                                                     // Current Symbol Table
extern symb * currentSymbol;                                                    // Used when encountering a new  identifier( also used for changing the symbol table)
                                                                                // to point to it

// Attributes used in the Parser

class Expression {                                                              // Class to implement different Attributes for expressions
public:
        bool isbool;                                                            // if the expression is bool or not


        symb * symp;                                                            // Pointer to its entry in the symbol table( valid only if non boolean entity)


        li truelist;                                                            // truelist(if boolean entity)     [ inherited ]
        li falselist;                                                           // falselist(if boolean entity)    [ inherited ]


        li nextlist;                                                            // nextlist for statements          [ synthesized ]
        Expression()                                                            // Constructor
        {
          ;
        }

        //Getter Setter Methods
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

class statement {                                                               // Class to store nextlist(list of index to backpatch) for statements
public:
        list < int > nextlist;                                                  // list of index to backpatch
        statement()
      {
        ;
      }
      //Getter setter methods
        void setNextlist(li nextlist);
        li getNextlist();
  };

class UnaryExpr                                                                 // Class to store different Attributes (including index address in memory for matrix)
{
public:
        typeEnum cat;                                                           // type of the entity such as double,matrix
        symb * loc;                                                             // Used for storing the index tranlation of an array element
        symb * symp;                                                            // Pointer to symbol table for the entry
        symbolType * type;                                                      // Pointer  to type object
        UnaryExpr()
        {
          ;
        }
        //Constructors
        symb* getSymp();
        symb* getLoc();
        typeEnum getCat();
        symbolType* getType();
        void setSymp(symb* symp);
        void setLoc(symb* loc);
        void setCat(typeEnum cat);
        void setType(symbolType* type);
};

// Functions to implement commonly used tasks

Expression * convertfrombool(Expression * );                                    // Create truelist and falselist for booleans
Expression * convertfrombool(Expression * e,Expression* e1);                    // Create truelist and falselist for booleans
template < typename T > string tostr(const T & t) {                             // convert any type to string
      return (SSTR(t));}
bool isFalse();                                                                 // check if boolean is false
void setUnaryOp(char& a,char b);                                                // Sets the unary operator while parsing

Expression * covertToBoolean(Expression * );                                    // Create truelist and falselist for booleans


#endif
