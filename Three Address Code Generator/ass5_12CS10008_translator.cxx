
#include "ass5_12CS10008_translator.h"
/************ Global variables *************/

symbolTable* globalSymbolTable;					// Global Symbbol Table
quads quadarray;						// Quads
type_e TYPE;					// Stores latest type specifier
bool gDebug = false;			// Debug mode
bool transRUN=false;
symbolTable* table;					// Points to current symbol table
sym* currsym; 					// points to latest function entry in symbol table
bool rowison=false;

/* Singleton Design Pattern */
Singleton* Singleton::pointerToSingleton= NULL;
Singleton::Singleton()
{

}
Singleton* Singleton::GetInstance()
{
	if (pointerToSingleton== NULL)
	{
		pointerToSingleton = new Singleton();
	}
	return pointerToSingleton;
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
	return y;
}
int sizeoftype (symtype* t){

	if(t->cat==_VOID)
		return 0;
	else if(t->cat==_CHAR)
		return size_of_char;
	else if(t->cat==_INT)
		return size_of_int;
	else if(t->cat==_DOUBLE)
		return size_of_double;							// TODO: handle pointer and matrix type
	else
		{
		switch (t->cat) {										// Pointers and matrix type have been handled
			case PTR:
				return size_of_pointer;
			case _MATRIX:
				return (t->row *t->column*size_of_double+8);
			case FUNC:
				return 0;
		}
	}
}
string returnTypeString (const symtype* t){
	if (t==NULL) return "null";

	if(t->cat==_VOID)
		return "void";
	else if(t->cat==_INT)
			return "int";
	else if(t->cat==_DOUBLE)
			return "double";
	else if(t->cat==_CHAR)
		return "char";						// TODO: handle pointer and matrix type
	else if(t->cat==PTR)
			return "ptr("+ returnTypeString(t->ptr)+")";
	else if(t->cat==_MATRIX)
			return "Matrix(" + tostr(t->row) + ", "+ tostr(t->column)+", double" + ")";
	else if (t->cat==FUNC)
		return "funct";
	else
			return "type";

}
symtype::symtype(type_e cat, symtype* ptr, int width):
	cat (cat),
	ptr (ptr),
	width (width) {};

sym* symbolTable::lookup (string name)
{
			sym* s;
			list <sym>::iterator it;
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
					s =  new sym (name);
					s->category = "local";
					table.push_back (*s);
					return &table.back();
			}
}

sym* gentemp (type_e t, string init)
{
			char n[20];
			sprintf(n, "t%02d", table->tcount++);
			sym* s = new sym (n, t);
			s-> init = init;
			s->category = "temp";
			if(t!=_MATRIX )
			{
		        table->table.push_back ( *s);
		   }
		  else
			{
		        table->tcount--;
		  }
			return &table->table.back();
}

sym* gentemp (symtype* t, string init,bool decl)
{
		    char n[20];
		    sprintf(n, "t%02d", table->tcount++);
		    sym* s = new sym (n);

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

		    if(t->cat!=_MATRIX || init=="transpose")
						{
		        		table->table.push_back ( *s);
		    		}
		    else
						{
		        		table->tcount--;
		    		}
		    if (init=="Mat_temp"||decl)
		        		table->tcount++;
		    return &table->table.back();
}
symbolTable::symbolTable (string name): tname (name), tcount(0) {}

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
					string name=this->tname;
					cout << symTab << setfill (' ') << left << setw(35)  <<name ;
					cout << right << setw(20) << "Parent: ";
					string nullname="null";
					if (this->parent!=NULL)
						cout << this -> parent->tname;
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
					int runOffset=it->offset;
					int currentSize=it->size;
					off += runOffset ;
					off +=  currentSize;
		            //cout<<it->size<<" "<<off<<endl;
				}
				if (it->nest!=NULL)
					tableList.push_back (it->nest);
			}
			traverse2(tableList,iterator)
			{
			    (*iterator)->computeOffsets();
			}
}
sym* sym::linkst(symbolTable* t)
{
	this->nest = t;
	string categ("function");
	this->category = categ;
}

ostream& operator<<(ostream& outstream, const symtype* t)
{
	// type_e cat = t->cat;
	string typeString = returnTypeString(t);
	outstream << typeString;
	return outstream;
}
ostream& operator<<(ostream& outstream, const sym* it)
{
				string name(it->name);
				symtype* type=it->type;
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
					outstream << it->nest->tname <<  endl;
				}
				else
				{
					string nullName("null");
					outstream << nullName <<  endl;

				}
				return outstream;
}
quad::quad (string result, string arg1, optype op, string arg2):
	result (result), arg1(arg1), arg2(arg2), op (op){};

quad::quad (string result, int arg1, optype op, string arg2):
	result (result), arg2(arg2), op (op) {
		this ->arg1 = SSTR(arg1);
	}
sym::sym (string name, type_e t, symtype* ptr, int width): name(name)
{
			type = new symtype (symtype(t, ptr, width));
			nest = NULL;
			string nullstring="";
			init = nullstring;
			category = nullstring;
			int zero=0;
			offset = zero;
			size = sizeoftype(type);
}
sym* sym::initialize (string initial)
{
	this->init = initial;
}
sym* sym::update(symtype* t)
{
	this->type = t;
	this -> size = sizeoftype(t);
	return this;
}
sym* sym::update(type_e t)
{
	this->type = new symtype(t);
	this->size = sizeoftype(this->type);
	return this;
}
void quad::update (int addr) {	// Used for backpatching address
	this ->result = addr;
}
void quad::print ()
{
	switch(op) {
		//Unary Operators
		case ADDRESS:		cout << result << " = &" << arg1;				break;
		case TRANSOP:       cout<<result<<"="<<arg1<<" .'";                      break;
		case BNOT:			cout << result 	<< " = ~" << arg1;				break;
		case LNOT:			cout << result 	<< " = !" << arg1;				break;
		case PARAM: 		cout << "param" <<" "<<result;
										break;
		case CALL: 			cout << result << " = " << "call " << arg1<< ", " << arg2;				break;
		case ARRR:	 		if (arg1!=arg2)
																cout <<result<< " = " << arg1 << "[" << arg2 << "]";
																else
																	cout << result << " = " << arg1 ;
														break;
		case ARRL:	 		if (result!=arg1)
																cout <<result<< "[" << arg1 << "]" <<" = " <<  arg2;
														else
																cout << result  <<" = " <<  arg2;
														break;
		case _RETURN: 		cout << "ret"<<" "<< result;				break;
		case PTRR:			cout <<result<< " "<<"= *" << arg1 ;				break;
		case PTRL:			cout << "*" << result	<< " = " << arg1 ;		break;
		case UMINUS:		cout << result 	<< " = -" << arg1;				break;
		case LABEL:			cout << result << ": ";					break;
		// Binary Operations
		case XOR:			cout << result << " = " << arg1 << " ^ " << arg2;				break;
		case MODULUS:			cout << result << " = " << arg1 << " % " << arg2;				break;
		case INOR:			cout << result << " = " << arg1 << " | " << arg2;				break;
		case BAND:			cout << result << " = " << arg1 << " & " << arg2;				break;
		case ADD:			cout << result << " = " << arg1 << " + " << arg2;				break;
		case MULT:			cout << result << " = " << arg1 << " * " << arg2;				break;
		case SUB:			cout << result << " = " << arg1 << " - " << arg2;				break;
		case DIVIDE:		cout << result << " = " << arg1 << " / " << arg2;				break;
		// Relational Operations
		case GreaterThan:			cout << "if " << arg1 <<  " > "  << arg2 << " goto " << result;				break;
		case GE:			cout << "if " << arg1 <<  " >= " << arg2 << " goto " << result;				break;
		case LT:			cout << "if " << arg1 <<  " < "  << arg2 << " goto " << result;				break;
		case LE:			cout << "if"<<" "<< arg1 << " "<<"<= " << arg2 << " goto " << result;				break;
		case GOTOOP:		cout << "goto " << result;						break;
		case EQOP:			cout << "if " << arg1 <<  " == " << arg2 << " goto " << result;				break;
		case NEOP:			cout << "if " << arg1 <<  " != " << arg2 << " goto " << result;				break;
		// Shift Operations
		case LEFTSHIFT:		cout << result << " = " << arg1 << " << " << arg2;
											break;
		case EQUAL:			cout <<result<< " "<<"="<<" " << arg1 ;
										break;
		case RIGHTSHIFT:		cout << result<< " = " << arg1 ;
										cout<< " >> " << arg2;				break;
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
	string arg1("arg1");
	cout << setw(8) << arg1;
	string arg2("arg2");
	cout << setw(8) << arg2;
	string result("result");
	cout << setw(8) << result << endl;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++)
	{
			cout << left << setw(8) << it - array.begin();
			cout << left << setw(8) << opCodeToString(it->op);
			string argument1(it->arg1),argument2(it->arg2),result(it->result);
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
			quadarray.array[*it].result = tostr(addr);
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
void emit(optype op, string result, string arg1, string arg2)
{
	quadarray.array.push_back(*(new quad(result,arg1,op,arg2)));

}
void emit(optype op, string result, int arg1, string arg2) {
	quadarray.array.push_back(*(new quad(result,arg1,op,arg2)));

}
string opCodeToString (int op) {
	switch(op) {
		//Unary Operators
		case ADDRESS:			return " &";
		case PTRR:				return " *R";
		case LNOT:				return " !";
		case UMINUS:			return " -";
		case BNOT:				return " ~";
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
		case GE:				return " >= ";
		case LE:				return " <= ";
		case GOTOOP:			return " goto ";
		default:				return " op ";
	}
}

int nextinstr()
{
	int instr= quadarray.array.size();
	return instr;
}
string NumberToString ( int Number )
{

	return SSTR(Number);
}
expr* convert2bool (expr* e) 															// Convert any expression to bool
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
expr* convertfrombool (expr* e) 																								// Convert any expression to bool
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
bool typecheck(sym*& s1, sym*& s2)
{ 	// Check if the symbols have same type or not
	symtype* type1 = s1->type;
	symtype* type2 = s2->type;
	if ( typecheck (type1, type2) )
				return true;
	else if (s1 = conv (s1, type2->cat) )
	 			return true;
	else if (s2 = conv (s2, type1->cat) )
				return true;
	else
				return false;
}
bool typecheck(symtype* t1, symtype* t2)																				// Check if the symbol types are same or not
{
			type_e cat1=t1->cat;
			type_e cat2=t2->cat;
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

sym* conv (sym* s, type_e t)
{
	sym* temp = gentemp(t);
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
	quadarray.print();


}
