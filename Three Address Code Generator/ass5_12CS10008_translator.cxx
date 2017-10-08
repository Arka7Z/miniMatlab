
#include "ass5_12CS10008_translator.h"
/************ Global variables *************/

symtab* globalSymbolTable;					// Global Symbbol Table
quads quadarray;						// Quads
type_e TYPE;					// Stores latest type specifier
bool gDebug = false;			// Debug mode
bool transRUN=false;
symtab* table;					// Points to current symbol table
sym* currsym; 					// points to latest function entry in symbol table
bool rowison=false;

/* Singleton Design Pattern */
Singleton* Singleton::pSingleton= NULL;
Singleton::Singleton() {
   // do init stuff
}
Singleton* Singleton::GetInstance() {
	if (pSingleton== NULL) {
		pSingleton = new Singleton();
	}
	return pSingleton;
}
list<int> makelist (int i)
{
	list<int> l(1,i);
	return l;
}
list<int> merge (list<int> &a, list <int> &b)
{
	a.merge(b);
	return a;
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

sym* symtab::lookup (string name)
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
symtab::symtab (string name): tname (name), tcount(0) {}

void symtab::print(int all)
{
					list<symtab*> tablelist;
					cout << setw(160) << setfill ('~') << "="<< endl;
					cout << "Symbol Table: " << setfill (' ') << left << setw(35)  << this -> tname ;
					cout << right << setw(20) << "Parent: ";
					if (this->parent!=NULL)
						cout << this -> parent->tname;
					else cout << "null" ;
					cout << endl;
					cout << setw(160) << setfill ('-') << "-"<< endl;
					cout << setfill (' ') << left << setw(16) << "Name";
					cout << left << setw(30) << "Type";
					cout << left << setw(12) << "Category";
					cout << left << setw(40) << "Init Val";
					cout << left << setw(8) << "Size";
					cout << left << setw(8) << "Offset";
					cout << left << "Nest" << endl;
					cout << setw(160) << setfill ('-') << "-"<< setfill (' ') << endl;

					traverse2(table,it)
					{
						cout << &*it;
						if (it->nest!=NULL) tablelist.push_back (it->nest);
					}
					cout << setw(160) << setfill ('-') << "-"<< setfill (' ') << endl;
					cout << endl;
					if (all)
					{
						traverse2(tablelist,iterator)
						{
						    (*iterator)->print();
						}
					}
}
void symtab::computeOffsets()
{
	list<symtab*> tablelist;
	int off;
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
			off = it->offset + it->size;
            //cout<<it->size<<" "<<off<<endl;
		}
		if (it->nest!=NULL)
			tablelist.push_back (it->nest);
	}
	traverse2(tablelist,iterator)
	{
	    (*iterator)->computeOffsets();
	}
}
sym* sym::linkst(symtab* t)
{
	this->nest = t;
	this->category = "function";
}

ostream& operator<<(ostream& os, const symtype* t)
{
	type_e cat = t->cat;
	string stype = returnTypeString(t);
	os << stype;
	return os;
}
ostream& operator<<(ostream& os, const sym* it)
{
				string name=it->name;
				symtype* type=it->type;
				string category=it->category;
				string init=it->init;
				os << left << setw(16) << name;
				os << left << setw(30) << type;
				os << left << setw(12) << category;
				os << left << setw(40) <<init;
				os << left << setw(8) << it->size;
				os << left << setw(8) << it->offset;
				os << left;
				if (it->nest != NULL)
				{
					os << it->nest->tname <<  endl;
				}
				else
				{
					os << "null" <<  endl;

				}
				return os;
}
quad::quad (string result, string arg1, optype op, string arg2):
	result (result), arg1(arg1), arg2(arg2), op (op){};

quad::quad (string result, int arg1, optype op, string arg2):
	result (result), arg2(arg2), op (op) {
		this ->arg1 = NumberToString(arg1);
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
sym* sym::initialize (string init) {
	this->init = init;
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
void quad::print () {
	switch(op) {
		//Unary Operators
		case ADDRESS:		cout << result << " = &" << arg1;				break;
		case TRANSOP:       cout<<result<<"="<<arg1<<" .'";                      break;
		case BNOT:			cout << result 	<< " = ~" << arg1;				break;
		case LNOT:			cout << result 	<< " = !" << arg1;				break;
		case PARAM: 		cout << "param " << result;				break;
		case CALL: 			cout << result << " = " << "call " << arg1<< ", " << arg2;				break;
		case ARRR:	 		if (arg1!=arg2)
																cout << result << " = " << arg1 << "[" << arg2 << "]";  
																else
																	cout << result << " = " << arg1 ;
														break;
		case ARRL:	 		if (result!=arg1)
																cout << result << "[" << arg1 << "]" <<" = " <<  arg2;
														else
																cout << result  <<" = " <<  arg2;
														break;
		case _RETURN: 		cout << "ret " << result;				break;
		case PTRR:			cout << result	<< " = *" << arg1 ;				break;
		case PTRL:			cout << "*" << result	<< " = " << arg1 ;		break;
		case UMINUS:		cout << result 	<< " = -" << arg1;				break;
		case LABEL:			cout << result << ": ";					break;
		// Binary Operations
		case XOR:			cout << result << " = " << arg1 << " ^ " << arg2;				break;
		case MODOP:			cout << result << " = " << arg1 << " % " << arg2;				break;
		case INOR:			cout << result << " = " << arg1 << " | " << arg2;				break;
		case BAND:			cout << result << " = " << arg1 << " & " << arg2;				break;
		case ADD:			cout << result << " = " << arg1 << " + " << arg2;				break;
		case MULT:			cout << result << " = " << arg1 << " * " << arg2;				break;
		case SUB:			cout << result << " = " << arg1 << " - " << arg2;				break;
		case DIVIDE:		cout << result << " = " << arg1 << " / " << arg2;				break;
		// Relational Operations
		case GT:			cout << "if " << arg1 <<  " > "  << arg2 << " goto " << result;				break;
		case GE:			cout << "if " << arg1 <<  " >= " << arg2 << " goto " << result;				break;
		case LT:			cout << "if " << arg1 <<  " < "  << arg2 << " goto " << result;				break;
		case LE:			cout << "if " << arg1 <<  " <= " << arg2 << " goto " << result;				break;
		case GOTOOP:		cout << "goto " << result;						break;
		case EQOP:			cout << "if " << arg1 <<  " == " << arg2 << " goto " << result;				break;
		case NEOP:			cout << "if " << arg1 <<  " != " << arg2 << " goto " << result;				break;
		// Shift Operations
		case LEFTOP:		cout << result << " = " << arg1 << " << " << arg2;				break;
		case EQUAL:			cout << result << " = " << arg1 ;								break;
		case RIGHTOP:		cout << result << " = " << arg1 << " >> " << arg2;				break;
		default:			cout << "op";							break;
	}
	cout << endl;
}
void quads::printtab()
{
	cout << "=== Quad Table ===" << endl;
	cout << setw(8) << "index";
	cout << setw(8) << " op";
	cout << setw(8) << "arg 1";
	cout << setw(8) << "arg 2";
	cout << setw(8) << "result" << endl;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++)
	{
		cout << left << setw(8) << it - array.begin();
		cout << left << setw(8) << opCodeToString(it->op);
		cout << left << setw(8) << it->arg1;
		cout << left << setw(8) << it->arg2;
		cout << left << setw(8) << it->result << endl;
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
	cout << setw(30) << setfill ('=') << "="<< endl;
	cout << "Quad Translation" << endl;
	cout << setw(30) << setfill ('-') << "-"<< setfill (' ') << endl;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++)
	{
		if (it->op != LABEL) {
			cout << "\t" << setw(10) << it - array.begin() << ":\t";
			it->print();
		}
		else {
			cout << "\n";
			it->print();
			cout << "\n";
		}
	}
	cout << setw(30) << setfill ('-') << "-"<< endl;
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
		case GT:				return " > ";
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
string NumberToString ( int Number ) {
	ostringstream ss;
	ss << Number;
	return ss.str();
}
expr* convert2bool (expr* e) {	// Convert any expression to bool
	if (!e->isbool) {
		e->falselist = makelist (nextinstr());
		emit (EQOP, "", e->symp->name, "0");
		e->truelist = makelist (nextinstr());
		emit (GOTOOP, "");
	}
}
expr* convertfrombool (expr* e) {	// Convert any expression to bool
	if (e->isbool) {
		e->symp = gentemp(_INT);
		backpatch (e->truelist, nextinstr());
		emit (EQUAL, e->symp->name, "true");
		emit (GOTOOP, tostr (nextinstr()+1));
		backpatch (e->falselist, nextinstr());
		emit (EQUAL, e->symp->name, "false");
	}
}
bool typecheck(sym*& s1, sym*& s2)
{ 	// Check if the symbols have same type or not
	symtype* type1 = s1->type;
	symtype* type2 = s2->type;
	if ( typecheck (type1, type2) ) return true;
	else if (s1 = conv (s1, type2->cat) ) return true;
	else if (s2 = conv (s2, type1->cat) ) return true;
	return false;
}
bool typecheck(symtype* t1, symtype* t2){ 	// Check if the symbol types are same or not
	if (t1 != NULL || t2 != NULL) {
		if (t1==NULL) return false;
		if (t2==NULL) return false;
		if (t1->cat==t2->cat) return (t1->ptr, t2->ptr);
		else return false;
	}
	return true;
}

sym* conv (sym* s, type_e t) {
	sym* temp = gentemp(t);
	switch (s->type->cat) {
		case _INT: {
			switch (t) {
				case _DOUBLE: {
					emit (EQUAL, temp->name, "int2double(" + s->name + ")");
					return temp;
				}
				case _CHAR: {
					emit (EQUAL, temp->name, "int2char(" + s->name + ")");
					return temp;
				}
			}
			return s;
		}
		case _DOUBLE: {
			switch (t) {
				case _INT: {
					emit (EQUAL, temp->name, "double2int(" + s->name + ")");
					return temp;
				}
				case _CHAR: {
					emit (EQUAL, temp->name, "double2char(" + s->name + ")");
					return temp;
				}
			}
			return s;
		}
		case _CHAR: {
			switch (t) {
				case _INT: {
					emit (EQUAL, temp->name, "char2int(" + s->name + ")");
					return temp;
				}
				case _DOUBLE: {
					emit (EQUAL, temp->name, "char2double(" + s->name + ")");
					return temp;
				}
			}
			return s;
		}
	}
	return s;
}
void changeTable (symtab* newtable) {	// Change current symbol table
	if (gDebug)	cout << "Symbol table changed from " << table->tname;
	table = newtable;
	if (gDebug)	cout << " to " << table->tname << endl;
}


// Functions for debugging
void printlist (list<int> l) {	// Print integers in list l
	for (list<int>::iterator iterator = l.begin(); iterator != l.end(); ++iterator) {
	    if (gDebug) cout << *iterator << " ";
	}
	cout << endl;
}

int  main (int argc, char* argv[]){
	if (argc>1) gDebug = true;
	globalSymbolTable = new symtab("Global");
	table = globalSymbolTable;
	yyparse();
	table->computeOffsets();
	table->print(1);
//	quadarray.printtab();
	quadarray.print();
	int n, x;
	cin >> n;
	if (n==10) {
		while (n--) {
			cin >> x;
			if(x==1) {
				gentemp(_DOUBLE);
			}
			else if (x==2) {
				emit(ADD, "a", "b", "c");
			}
		}
	}

};
