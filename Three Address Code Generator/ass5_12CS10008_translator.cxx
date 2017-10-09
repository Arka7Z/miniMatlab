
#include "ass5_12CS10008_translator.h"
/************ Global variables *************/

symbolTable* globalSymbolTable;					// Global Symbbol Table
quads quadArray;						// Quads
typeEnum TYPE;					// Stores latest type specifier
bool gDebug = false;			// Debug mode
bool transRUN=false;
symbolTable* table;					// Points to current symbol table
symb* currentSymbol; 					// points to latest function entry in symbol table
bool rowison=false;

// /* Singleton Design Pattern */
// Singleton* Singleton::pointerToSingleton= NULL;
// Singleton::Singleton()
// {
//
// }
// Singleton* Singleton::GetInstance()
// {
// 	if (pointerToSingleton== NULL)
// 	{
// 		pointerToSingleton = new Singleton();
// 	}
// 	return pointerToSingleton;
// }

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


void setUnaryOp(char& a, char b)
{
	a=b;
}
list<int> makelist (int i)
{
	list<int> l;
	l.push_back(i);
	return l;
}
list<int> merge(list<int> &x, list <int> &y)
{
	x.merge(y);
	return x;
}
li merge(li &x, li& y, li &z)
{
	x.merge(y);
	z.merge(x);
	return z;
}
int calculateSizeOfType (symbolType* t){

	typeEnum cat=t->cat;

	if(cat==_VOID)
		return 0;
	else if(cat==_CHAR)
		return size_of_char;
	else if(cat==_INT)
		return size_of_int;
	else if(cat==_DOUBLE)
		return size_of_double;							// TODO: handle pointer and matrix type
	else
		{
		switch (cat) {										// Pointers and matrix type have been handled
			case PTR:
				return size_of_pointer;
			case _MATRIX:
				return (t->row *t->column*size_of_double+8);
			case FUNC:
				return 0;
		}
	}
}
string returnTypeString (const symbolType* t){
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
		return "char";						// TODO: handle pointer and matrix type
	else if(category==PTR)
			return "ptr("+ returnTypeString(t->ptr)+")";
	else if(category==_MATRIX)
			return "Matrix(" + tostr(t->row) + ", "+ tostr(t->column)+", double" + ")";
	else if (category==FUNC)
		return "funct";
	else
			return "type";

}
symbolType::symbolType(typeEnum cat, symbolType* ptr, int width):
	cat (cat),
	ptr (ptr),
	width (width) {};

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

symb* gentemp (typeEnum t, string init)
{
			char n[20];
			sprintf(n, "t%02d", table->tempCount++);
			symb* s = new symb (n, t);
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

symb* gentemp (symbolType* t, string init,bool decl)
{
		    char n[20];
				typeEnum category=t->cat;
		    sprintf(n, "t%02d", table->tempCount++);
		    symb* s = new symb (n);

		    if(init!="transpose")
		       { s-> init = init;
		          s->type = t;
		        }
		    if(init == "transpose"){
		        int a,b;
		        a=s->type->row = t->column;
		        s->type->cat=_MATRIX;
		        b=s->type->column = t->row;

		        s->size = (t->row*t->column*8 + 8);
		    }
		    s->category = "temp";
		    if (init=="Mat_temp")
		        {
		            //cout<<"HELOO"<<endl;
		            s->init="";
								s->type->row = t->column;
		            s->type->column = t->row;
		            s->size = (t->row*t->column*8 + 8);
		            table->table.push_back ( *s);
		        }
		    if (decl)
		         {
							 	s->init=init;
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
symbolTable::symbolTable (string name): tableName (name), tempCount(0) {}

void symbolTable::print(int all)
{
					list<symbolTable*> tablelist;
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

					traverse2(table,it)
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
						    (*iterator)->print();
						}
					}
}
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
				if (it->nest!=NULL)
					tableList.push_back (it->nest);
			}
			traverse2(tableList,iterator)
			{
			    (*iterator)->computeOffsets();
			}
}
bool isFalse()
{
	return false;
}
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
quad::quad (string result, string argument1, opTypeEnum op, string argument2):
	result (result), argument1(argument1), argument2(argument2), op (op){};

quad::quad (string result, int argument1, opTypeEnum op, string argument2):
	result (result), argument2(argument2), op (op) {
		this ->argument1 = SSTR(argument1);
	}
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
symb* symb::initialize (string initial)
{
	this->init = initial;
}
symb* symb::initialise (string initial)
{
	this->init = initial;
}
symb* symb::update(symbolType* t)
{
	this->type = t;
	this -> size = calculateSizeOfType(t);
	return this;
}
symb* symb::update(typeEnum t)
{
	this->type = new symbolType(t);
	this->size = calculateSizeOfType(this->type);
	return this;
}
void quad::update (int addr) {	// Used for backpatching address
	this ->result = addr;
}
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
		case LABEL:			cout << result << ": ";					break;
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
		case RIGHTSHIFT:		cout << result<< " = " << argument1 ;
										cout<< " >> " << argument2;				break;
		default:			cout << "op";							break;
	}
	cout << endl;
}
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
void backpatch (list <int> l, int addr)
{
	traverse2(l,it)
		{
			quadArray.array[*it].result = tostr(addr);
		}

}
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
		if (it->op != LABEL)
		{
			cout << "\t" << setw(10) << it - array.begin() << ":\t";
			it->print();
		}
		else
		{
			cout << "\n";
			it->print();
			printf("\n" );
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
void emit(opTypeEnum op, string result, string argument1, string argument2)
{
	quadArray.array.push_back(*(new quad(result,argument1,op,argument2)));

}
void emit(opTypeEnum op, string result, int argument1, string argument2) {
	quadArray.array.push_back(*(new quad(result,argument1,op,argument2)));

}
string opCodeToString (int op) {
	switch(op) {
		//UnaryExpr Operators
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

int nextinstr()
{
	int instr= quadArray.array.size();
	return instr;
}
string int2string ( int Number )
{

	return SSTR(Number);
}
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
							else if(t==_DOUBLE)
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
void changeTable (symbolTable* newtable) 					// Change current symbol table
{

	table = newtable;

}




int  main (int argc, char* argv[])
{

	globalSymbolTable = new symbolTable("Global");
	table = globalSymbolTable;
	yyparse();
	table->computeOffsets();
	table->print(1);
	quadArray.print();


}
