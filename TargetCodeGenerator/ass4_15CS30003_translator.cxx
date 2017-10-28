
#include "ass4_15CS30003_translator.h"
// GLOBALS

symbolTable* globalSymbolTable;																									// Global Symbbol Table
quads quadArray;																																// Quad Array
typeEnum TYPE;																																	// Stores the latest type specifier
bool gDebug = false;
bool transRUN=false;																														// Boolean to store if a matrix transpose is currrently running
symbolTable* table;																															// Pointer to current symbol table
symb* currentSymbol; 																														// Pointer to the latest function entry
bool rowison=false;


//Getter and Setter Methods
void symbolType::setWidth(int width)
{
	this->width=width;
}
void symbolType::setColumn(int column)
{
	this->column=column;
}
void symbolType::setRow(int row)
{
	this->row=row;
}
void symbolType::setCat(typeEnum cat)
{
	this->cat=cat;
}
void  symbolType::setPtr(symbolType* ptr)
{
	this->ptr=ptr;
}
int symbolType::getWidth()
{
	return this->width;
}
int symbolType::getRow()
{
	return this->row;
}int symbolType::getColumn()
{
	return this->column;
}
symbolType* symbolType::getPtr()
{
	return this->ptr;
}
typeEnum symbolType::getCat()
{
	return this->cat;
}

string symb::getName()
{
	return this->name;
}
string symb::getInit()
{
	return this->init;
}
string symb::getCategory()
{
	return this->category;
}
int symb::getOffset()
{
	return this->offset;
}
symbolTable* symb::getNest()
{
	return this->nest;
}
symbolType* symb::getType()
{
	return this->type;
}
void symb::setName(string name)
{
	this->name=name;
}
void symb::setInit(string init)
{
	this->init=init;
}
void symb::setCategory(string category)
{
	this->category;
}
void symb::setOffset(int offset)
{
	this->offset=offset;
}
void symb::setNest(symbolTable* nest)
{
	this->nest=nest;
}


string symbolTable::getTableName()
{
	return tableName;
}
int symbolTable::getTempCount()
{
	int tcount=this->tempCount;
	return tcount;
}
list<symb> symbolTable::getTable()
{
	return table;
}
void symbolTable::setTableName(string param)
{
	tableName=param;
}
void symbolTable::setTempCount(int count)
{
	tempCount=count;
}
void symbolTable::setTable(list<symb> tableParam)
{
	table=tableParam;
}
void symbolTable::setParent(symbolTable * parent)
{
	this->parent=parent;
}
opTypeEnum quad::getOpCode()
{
	opTypeEnum opcode=this->op;
	return opcode;
}
string quad::getResult()
{
	string result=this->result;
	return result;
}
string quad::getArgument1()
{
	string argument1=this->argument1;
	return argument1;
}
string quad::getArgument2()
{
	string argument2=this->argument2;
	return argument2;
}
void quad::setOpCode(opTypeEnum opcode)
{
	op=opcode;
}
void quad::setResult(string Result)
{
	result=Result;
}
void quad::setArgument1(string argument1)
{
	this->argument1=argument1;
}
void quad::setArgument2(string argument2)
{
	this->argument2=argument2;
}

vector<quad> quads::getArray()
{
	return this->array;
}
void quads::setArray(vector<quad> v)
{
	array=v;
}

symb* UnaryExpr::getSymp()
{
	return symp;
}
symb* UnaryExpr::getLoc()
{
	return loc;
}
typeEnum UnaryExpr::getCat()
{
	return cat;
}
symbolType* UnaryExpr::getType()
{
	return type;
}
void UnaryExpr::setSymp(symb* symp1)
{
	symp=symp1;
}
void UnaryExpr::setLoc(symb* loc)
{
	this->loc=loc;
}
void UnaryExpr::setCat(typeEnum cat)
{
	this->cat=cat;
}
void UnaryExpr::setType(symbolType* type)
{
	this->type= type;
}

symb* Expression::getSymp()
{
	return this->symp;
}
li Expression::getTruelist()
{
	return truelist;
}
li Expression::getFalselist()
{
	return falselist;
}
void Expression::setIsBool(bool flag)
{
	isbool=flag;
}
void Expression::setSymp(symb* symp)
{
	this->symp=symp;
}
void Expression::setTruelist(li truelist)
{
	this->truelist=truelist;
}
void Expression::setFalselist(li falselist)
{
	this->falselist=falselist;
}
void Expression::setNextlist(li nextlist)
{
	this->nextlist=nextlist;
}
li Expression::getNextlist()
{
	return this->nextlist;
}
void statement::setNextlist(li nextlist)
{
	this->nextlist=nextlist;
}
li statement::getNextlist()
{
	return this->nextlist;
}



void setUnaryOp(char& a, char b)                                                // Set the unary operator while parsing
{
	a=b;
}
list<int> makelist (int i)																											// Make list function for booleans
{
	list<int> l;
	l.push_back(i);
	return l;
}

list<int> merge(list<int> &x, list <int> &y)																		// Merge two lists and return the merged list
{
	x.merge(y);
	return x;
}

li merge(li &x, li& y, li &z)																										// Merge three lists and return the merged list
{
	x.merge(y);
	z.merge(x);
	return z;
}

int calculateSizeOfType (symbolType* t)																					// Input: type object. Output: size of the type
{

	typeEnum cat=t->cat;

	if(cat==_VOID)
			return 0;
	else if(cat==_CHAR)
			return size_of_char;
	else if(cat==_INT)
			return size_of_int;
	else if(cat==_DOUBLE)
			return size_of_double;																										// TODO: handle pointer and matrix type
	else																																					// Matrix type handled separately
	{
			switch (cat)
			{																																					// Pointers and matrix type have been handled
					case PTR:
							return size_of_pointer;
					case _MATRIX:
							return (t->row *t->column*size_of_double+8);											// computing matrix size with the given dimensions
					case FUNC:
							return 0;
				}
	}
}
string returnTypeString (const symbolType* t)																		// Input: type object. Output: type as string
{
			if (t==NULL)
				return "null";
			typeEnum category=t->cat;
			if(category==_VOID)
				return "void";
			else if(category==_INT)
				return "int";
			else if(category==_DOUBLE)
				return "double";
			else if(category==_CHAR)
				return "char";																													// TODO: handle pointer and matrix type
			else if(category==PTR)
				return "ptr("+ returnTypeString(t->ptr)+")";
			else if(category==_MATRIX)
				return "Matrix(" + tostr(t->row) + ", "+ tostr(t->column)+", double" + ")";

			else
				return "type";

}
symbolType::symbolType(typeEnum cat, symbolType* ptr, int width):								// Constructor for symbolType object.Input: type,nested pointer,width. Output: object
cat (cat),
ptr (ptr),
width (width) {};


// Input: name(lexeme). Output: pointer to its entry in the symbol table
// traverses the current symbol table and returns the entry where name match is found
symb* symbolTable::lookup (string name)
{
	symb* s;
	list <symb>::iterator it;
	traverse(table,it)
	{
		if (it->name == name )
		break;
	}
	if (it!=table.end() )
	{
		return &*it;
	}
	else
	{
		s =  new symb (name);
		s->category = "local";
		table.push_back (*s);
		return &table.back();
	}
}

/*
	Generate temporaries
	input: type such as int,double and initial value
	Output: pointer to the temporary generated
	Algorithm:	The temporary is generated and pushed back while incrementing the number of temporaries simulataneoulsy
							Special case of matrix is handled separately

*/
symb* gentemp (typeEnum t, string init)
{
	char name[20];
	sprintf(name, "t%02d", table->tempCount);
	table->tempCount++;
	symb* s = new symb (name, t);
	s-> init = init;
	s->category = "temp";
	if(t!=_MATRIX )
	{
		table->table.push_back ( *s);
	}
	else
	{
		table->tempCount--;
	}
	return &table->table.back();
}

/*
	Generate temporaries
	input: symb type object,initial value
				 and
				 A boolean that indicates if a declarartiong phase is running for matrix
	Output: pointer to the temporary generated
	Algorithm:	The temporary is generated and pushed back while incrementing the number of temporaries SUITABLY
							Special case of matrix type temporary, temporary during transpose operation and binary operation
							for matrix is handled separately as indicated in the comments

*/
symb* gentemp (symbolType* t, string init,bool decl)
{
			char n[20];																																// Name of the temporary.Format: t[0-9]*
			typeEnum category=t->cat;
			sprintf(n, "t%02d", table->tempCount++);
			symb* s = new symb (n);

			if(init!="transpose")																										  // Since s is a pointer hence row and column size assignments are done suitably separately
			{
				 s-> init = init;
				 s->type = t;
			}
			if(init == "transpose")
			{
					int a,b;
					a=s->type->row = t->column;																						// Reverse row and columns during transpose operation
					b=s->type->column = t->row;
					s->type->cat=_MATRIX;																									// Set the category of temporary as Matrix
					s->size = (t->row*t->column*8 + 8);																		// Set size of the Matrix type temp
			}
			s->category = "temp";																											// Type of the category in symbolTable is temporary
			if (init=="Mat_temp")																											// Handling matrix type temporary
			{
				s->init="";																															// Setting row,column and size
				s->type->row = t->column;
				s->type->column = t->row;
				s->size = (t->row*t->column*8 + 8);
				table->table.push_back ( *s);
			}
			if (decl)																																	// Case when matrix is being declared(initialisation stage)
			{
				s->init=init;																														// Set initial value, dimensions and size
				s->type->row = t->row;
				s->type->column = t->column;
				s->size = (t->row*t->column*8 + 8);
				table->table.push_back ( *s);
			}

			if(category!=_MATRIX || init=="transpose")
			{
				table->table.push_back ( *s);
			}
			else
			{
				table->tempCount--;
			}
			if (init=="Mat_temp"||decl)
			table->tempCount++;
			return &table->table.back();
}

/*
		Input: Name of the symbolTable
		Output: Symbol Table with number of temporaries initialised to 0
*/
symbolTable::symbolTable (string name): tableName (name), tempCount(0) {}

/*
		Print the symbol table (Including the nested ones) with suitable formatting
		input: Flag denoting if the current symbol table is to be printed or the nested tables as well
					 all=0 => Current symbol Table only
					 all=1 => Nested symbol tables as well
*/
void symbolTable::print(int all)
{
			list<symbolTable*> tablelist;                                             // List of symbol tables to store nested tables as well
			char delimiter='~';

			int i=0;
			while(i<150)
			{
				cout<<delimiter;
				i++;
			}
			cout<<endl;

			string symTab="Symbol Table :";
			string name=this->tableName;
			cout << symTab << setfill (' ') << left << setw(35)  <<name ;
			cout << right << setw(20) << "Parent: ";
			string nullname="null";
			if (this->parent!=NULL)
					cout << this -> parent->tableName;
			else
					cout <<nullname ;
			printf("\n");

			i=0;
			while(i<150)
			{
					cout<<delimiter;
					i++;
			}
			cout<<endl;

			string Name="Name";
			string Type("Type");
			string Category("Category");
			string Initial("Initial Value");
			string Nested("Nested Table");
			string Offset("Offset");
			cout << setfill (' ') << left << setw(16) <<Name;
			cout << left << setw(30) << Type;
			cout << left << setw(12) << Category;
			cout << left << setw(40) << Initial;
			cout << left << setw(8) << "Size";
			cout << left << setw(8) << Offset;
			cout << left << Nested ;
			cout<<endl;

			char delimiter2='-';
			i=0;
			while(i<150)
			{
				cout<<delimiter2;
				i++;
			}
			cout<<endl;

			traverse2(table,it)                                                       // Store the nested functions( Symbol tables )
			{
				cout << &*it;
				if (it->nest!=NULL)
						tablelist.push_back (it->nest);
			}

			i=0;
			while(i<150)
			{
				cout<<delimiter2;
				i++;
			}
			cout<<endl;
			cout << endl;
			if (all)
			{
				traverse2(tablelist,iterator)
				{
					(*iterator)->print();                                                 // Call print recursive
				}
			}
}

/*
		Input: Undefined ( class member function)
		Output: void
		Task implemented: Calculates and stores the offset values for each entry in each of the symbol tables
											using their size once all the symbol table( for all the fucntions ) has been constructed
*/
void symbolTable::computeOffsets()
{
		list<symbolTable*> tableList;
		int off=0;

		traverse2(table,it)
		{
				if (it==table.begin())
				{
						it->offset = 0;
						off = it->size;
				}
				else
				{
						it->offset = off;
						//int runOffset=it->offset;
						int currentSize=it->size;
						//off += runOffset ;
						off +=  currentSize;
						// cout<<it->size<<" "<<off<<endl;
				}
				if (it->nest!=NULL)																											// Store the nested tables as well
					tableList.push_back (it->nest);
		}
		traverse2(tableList,iterator)																								// Calculate their Offset recursively
		{
			(*iterator)->computeOffsets();
		}
}
bool isFalse()
{
	return false;
}

/*
	Input: Pointer to symbolbtable
	Task implemented:	sets the nesting of the function(the calling object) to the symbol table t
*/
symb* symb::linkst(symbolTable* t)
{
	this->nest = t;
	string categ("function");
	this->category = categ;
}

ostream& operator<<(ostream& outstream, const symbolType* t)
{
		// typeEnum cat = t->cat;
		string typeString = returnTypeString(t);
		outstream << typeString;
		return outstream;
}
ostream& operator<<(ostream& outstream, const symb* it)
{
			string name(it->name);
			symbolType* type=it->type;
			string category(it->category);
			string init(it->init);
			typeof(it->size) size=it->size;
			typeof(it->offset) offset=it->offset;
			outstream << left << setw(16) << name;
			outstream << left << setw(30) << type;
			outstream << left << setw(12) << category;
			outstream << left << setw(40) <<init;
			outstream << left << setw(8) << size;
			outstream << left << setw(8) << offset;
			outstream << left;
			if (it->nest != NULL)
			{
					outstream << it->nest->tableName <<  endl;
			}
			else
			{
					string nullName("null");
					outstream << nullName <<  endl;

			}
			return outstream;
}

/*
	Quad Constructor
	Input: Quad result,argument1,argument2 & opcode
	Output: Quad
*/
quad::quad (string result, string argument1, opTypeEnum op, string argument2):result (result), argument1(argument1), argument2(argument2), op (op){};


/*
	TO SUPPORT OVERLOADING
	Quad Constructor
	Input: Quad result,argument1,argument2 & opcode
	Output: Quad
*/
quad::quad (string result, int argument1, opTypeEnum op, string argument2):
result (result), argument2(argument2), op (op) {
	this ->argument1 = SSTR(argument1);
}

/*
	CONSTRUCTOR
	Input: Name,type enum, pointer to type object, width
	Output: Entry in the symbol table
*/
symb::symb (string name, typeEnum t, symbolType* ptr, int width): name(name)
{
	type = new symbolType (symbolType(t, ptr, width));
	nest = NULL;
	string nullstring="";
	init = nullstring;
	category = nullstring;
	int zero=0;
	offset = zero;
	size = calculateSizeOfType(type);
}

/*
	Sets the initial value of the entity in the symbol table
	Input: initial value as string
*/
symb* symb::initialize (string initial)
{
	this->init = initial;
}

/*
	Dummy function as above to fix a few bugs in the parser
*/
symb* symb::initialise (string initial)
{
	this->init = initial;
}
/*
	A method to update different fields of an existing entry.
	Input: Pointer to symbol type object
*/
symb* symb::update(symbolType* t)
{
	this->type = t;
	this -> size = calculateSizeOfType(t);
	return this;
}
/*
	A method to update different fields of an existing entry.
	Input: type enumeration
*/
symb* symb::update(typeEnum t)
{
	this->type = new symbolType(t);
	this->size = calculateSizeOfType(this->type);
	return this;
}



/*
	Print and Individual Quad by cheching the opcode of the quad
	Input & Output: Void
*/
void quad::print ()
{
	switch(op) {
		//UnaryExpr Operators
				case ADDRESS:		cout << result << " = &" << argument1;				break;
				case TRANSOP:       cout<<result<<"="<<argument1<<" .'";                      break;
				case BINARYNOT:			cout << result 	<< " = ~" << argument1;				break;
				case LNOT:			cout << result 	<< " = !" << argument1;				break;
				case PARAM: 		cout << "param" <<" "<<result;
				break;
				case CALL: 			cout << result << " = " << "call " << argument1<< ", " << argument2;				break;
				case ARRR:	 		if (argument1!=argument2)
				cout <<result<< " = " << argument1 << "[" << argument2 << "]";
				else
				cout << result << " = " << argument1 ;
				break;
				case ARRL:	 		if (result!=argument1)
				cout <<result<< "[" << argument1 << "]" <<" = " <<  argument2;
				else
				cout << result  <<" = " <<  argument2;
				break;
				case _RETURN: 		cout << "ret"<<" "<< result;				break;
				case PTRR:			cout <<result<< " "<<"= *" << argument1 ;				break;
				case PTRL:			cout << "*" << result	<< " = " << argument1 ;		break;
				case UNARYMINUS:		cout << result 	<< " = -" << argument1;				break;
				case FUNC:			cout << result << ": ";					break;
				// Binary Operations
				case XOR:			cout << result << " = " << argument1 << " ^ " << argument2;				break;
				case MODULUS:			cout << result << " = " << argument1 << " % " << argument2;				break;
				case INCLUSIVEOR:			cout << result << " = " << argument1 << " | " << argument2;				break;
				case BINARYAND:			cout << result << " = " << argument1 << " & " << argument2;				break;
				case ADD:			cout << result << " = " << argument1 << " + " << argument2;				break;
				case MULT:			cout << result << " = " << argument1 << " * " << argument2;				break;
				case SUB:			cout << result << " = " << argument1 << " - " << argument2;				break;
				case DIVIDE:		cout << result << " = " << argument1 << " / " << argument2;				break;
				// Relational Operations
				case GreaterThan:			cout << "if " << argument1 <<  " > "  << argument2 << " goto " << result;				break;
				case GREATERTHANEQ:			cout << "if " << argument1 <<  " >= " << argument2 << " goto " << result;				break;
				case LT:			cout << "if " << argument1 <<  " < "  << argument2 << " goto " << result;				break;
				case LE:			cout << "if"<<" "<< argument1 << " "<<"<= " << argument2 << " goto " << result;				break;
				case GOTOOP:		cout << "goto " << result;						break;
				case EQOP:			cout << "if " << argument1 <<  " == " << argument2 << " goto " << result;				break;
				case NEOP:			cout << "if " << argument1 <<  " != " << argument2 << " goto " << result;				break;
				// Shift Operations
				case LEFTSHIFT:		cout << result << " = " << argument1 << " << " << argument2;
				break;
				case EQUAL:			cout <<result<< " "<<"="<<" " << argument1 ;
				break;
				case EQUALSTR:  cout <<result<< " "<<"="<<" " << argument1 ;
				break;
				case RIGHTSHIFT:		cout << result<< " = " << argument1 ;
				case FUNCEND:		break;

				cout<< " >> " << argument2;				break;
				default:			cout << "op";							break;

	}
	cout << endl;
}

/*
	Print  quad array correspoding to a label(function) in a suitable formatted fashion.
	Input and Output: void
*/
void quads::printtab()
{
	printf("--Quad Table----------------------------------------------------------------\n");
	string Index("index");
	cout << setw(8) << Index;
	string op("op");
	cout << setw(8) << op;
	string argument1("argument1");
	cout << setw(8) << argument1;
	string argument2("argument2");
	cout << setw(8) << argument2;
	string result("result");
	cout << setw(8) << result << endl;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++)
	{
		cout << left << setw(8) << it - array.begin();
		cout << left << setw(8) << opCodeToString(it->op);
		string argument1(it->argument1),argument2(it->argument2),result(it->result);
		cout << left << setw(8) <<argument1;
		cout << left << setw(8) << argument2;
		cout << left << setw(8) << result;
		cout<<endl;

	}
}

/*
	input: The address the lists(result) is to be backpatched to
	Output: void
*/
void quad::update (int addr)
{	// Used for backpatching address
	this ->result = addr;														// IN the quads the result field stores the label of GOTO statements
}


/*
	input: List to backpatch to the address(int addr)
	A global function to insert addr as the target label for each of the quad’s on the list
	indexed by l.
*/
void backpatch (list <int> l, int addr)
{
	traverse2(l,it)
	{
		quadArray.array[*it].result = tostr(addr);
	}

}
/*
	input & ouptut: void
	Prints the quad array corresponding to all the labels ie the entire quad translation
*/
void quads::print ()
{
	char delimiter='~';
	int i=0;
	while (i<150)
	{
		cout<<delimiter;
		i++;
	}
	cout<<endl;
	cout << "Quad Translation" << endl;
	char delimiter2='-';
	i=0;
	while(i<150)
	{
		cout<<delimiter2;
		i++;
	}
	cout<<endl;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++)
	{
		switch (it->op) {
					case FUNC:
						cout << "\n";
						it->print();
						cout << "\n";
						break;
					case FUNCEND:
						break;
					default:
						cout << "\t" << setw(4) << it - array.begin() << ":\t";
						it->print();
				}
	}
	i=0;
	while(i<150)
	{
		cout<<delimiter2;
		i++;
	}
	cout<<endl;
}

/*
	Task:	add a (newly generated) quad to the quad array
	input:	opcode,result,argument1,argument2
	ouptut: void
*/
void emit(opTypeEnum op, string result, string argument1, string argument2)
{
	quadArray.array.push_back(*(new quad(result,argument1,op,argument2)));

}
/*
	Task:	add a (newly generated) quad to the quad array      || OVERLOADING support
	input:	opcode,result,argument1,argument2
	ouptut: void
*/
void emit(opTypeEnum op, string result, int argument1, string argument2) {
	quadArray.array.push_back(*(new quad(result,argument1,op,argument2)));

}

/*
	Input: flag denoting opcode
	Output: Opcode operator as a string
*/
string opCodeToString (int op) {
	switch(op) {
		//UnaryOperators
		case ADDRESS:			return " &";
		case PTRR:				return " *R";
		case LNOT:				return " !";
		case UNARYMINUS:			return " -";
		case BINARYNOT:				return " ~";
		case CALL: 				return " call ";
		case ARRR:	 			return " =[]R";
		case _RETURN: 			return " ret";
		case PTRL:				return " *L";
		case PARAM: 			return " param ";

		//Binary Operators
		case MULT:				return " * ";
		case ADD:				return " + ";
		case SUB:				return " - ";
		case DIVIDE:			return " / ";
		case EQUAL:				return " = ";
		case EQUALSTR:    return " = ";
		case EQOP:				return " == ";
		case NEOP:				return " != ";
		case LT:				return " < ";
		case GreaterThan:				return " > ";
		case GREATERTHANEQ:				return " >= ";
		case LE:				return " <= ";
		case GOTOOP:			return " goto ";
		default:				return " op ";
	}
}

/*
	input: void
	Output:	returns the next instruction index
	The index is used to backpatch while dealing with conditional statements etc.
*/
int nextinstr()
{
	int instr= quadArray.array.size();
	return instr;
}

/*
	Input: integer
	ouptut: the integer as a string
*/
string int2string ( int Number )
{

	return SSTR(Number);
}

/*
	input:pointer to expression class object
	Task implemented: Create truelist and falselist for booleans as well add quads suitably to the quad array
*/
Expression* covertToBoolean (Expression* e) 															// Convert any expression to bool
{
	if (!e->isbool)
	{
		e->falselist = makelist (nextinstr());
		string nullstring="";
		emit (EQOP, nullstring, e->symp->name, SSTR(0));
		e->truelist = makelist (nextinstr());
		emit (GOTOOP, nullstring);
	}
}

/*
	input:pointer to expression class object
	Task implemented: add quads suitably to the quad array and backpatch the truelist and falselist
*/
Expression* convertfrombool (Expression* e) 																								// Convert any expression to bool
{
	if (e->isbool)
	{
		e->symp = gentemp(_INT);
		backpatch (e->truelist, nextinstr());
		string expression_name(e->symp->name);
		emit (EQUAL, expression_name, "true");
		emit (GOTOOP, tostr (nextinstr()+1));
		backpatch (e->falselist, nextinstr());
		emit (EQUAL, expression_name, "false");
	}
}

/*
	|| OVERLOADING ||
	input:pointers to two expression class object
	Task implemented: add quads suitably to the quad array and backpatch the truelist and falselist
*/
Expression* convertfrombool (Expression* e,Expression* e1) 																								// Convert any expression to bool
{
	if (e->isbool)
	{
		e->symp = gentemp(_INT);
		backpatch (e->truelist, nextinstr());
		string expression_name(e->symp->name);
		emit (EQUAL, expression_name, "true");
		emit (GOTOOP, tostr (nextinstr()+1));
		backpatch (e->falselist, nextinstr());
		emit (EQUAL, expression_name, "false");
	}
	if (e1->isbool)
	{
		e1->symp = gentemp(_INT);
		backpatch (e1->truelist, nextinstr());
		string expression_name(e1->symp->name);
		emit (EQUAL, expression_name, "true");
		emit (GOTOOP, tostr (nextinstr()+1));
		backpatch (e->falselist, nextinstr());
		emit (EQUAL, expression_name, "false");
	}
}


bool typecheck(symb*& s1, symb*& s2)
{ 	// Check if the symbols have same type or not
		symbolType* type1 = s1->type;
		symbolType* type2 = s2->type;
		if ( typecheck (type1, type2) )
				return true;
		else if (s1 = conv (s1, type2->cat) )
				return true;
		else if (s2 = conv (s2, type1->cat) )
				return true;
		else
				return false;
}

/*

*/
bool typecheck(symbolType* t1, symbolType* t2)																				// Check if the symbol types are same or not
{
	typeEnum cat1=t1->cat;
	typeEnum cat2=t2->cat;
	if (!(t1 == NULL && t2 == NULL) )
	{
		if (!(t2!=NULL))
		return false;
		if (!(t1!=NULL))
		return false;
		if (!(cat1!=cat2))
		return (t1->ptr, t2->ptr);
		else
		return false;
	}
	return true;
}

symb* conv (symb* s, typeEnum t)
{
	symb* temp = gentemp(t);
	switch (s->type->cat)
	{
		case _INT:
		{
			if (t==_DOUBLE)
			{
				emit (EQUAL, temp->name, "int2double(" + s->name + ")");
				return temp;
			}
			else if(t==_CHAR)
			{
				emit (EQUAL, temp->name, "int2char(" + s->name + ")");
				return temp;
			}
			else
			return s;

		}
		case _DOUBLE:
		{
			if (t==_INT)
			{
				emit (EQUAL, temp->name, "double2int(" + s->name + ")");
				return temp;
			}
			else if(t==_CHAR)
			{
				emit (EQUAL, temp->name, "double2char(" + s->name + ")");
				return temp;
			}
			else
			return s;
		}
		case _CHAR:
		{

			if (t==_INT)
			{
				emit (EQUAL, temp->name, "char2int(" + s->name + ")");
				return temp;
			}
			else if(t==_MATRIX)
			{
				emit (EQUAL, temp->name, "char2double(" + s->name + ")");
				return temp;
			}
			else
			return s;
		}
	}
	return s;
}

/*
	input: pointer to a symbol table
	Output: void
	Task implemented: changes the symbol table to the symbol table given by the pointer to it during fucntions declaration
*/
void changeTable (symbolTable* newtable) 					// Change current symbol table
{

	table = newtable;

}


//
//
// int  main (int argc, char* argv[])
// {
//
// 	globalSymbolTable = new symbolTable("Global");
// 	table = globalSymbolTable;
// 	yyparse();
// 	table->computeOffsets();
// 	table->print(1);
// 	quadArray.print();
//
//
// }
