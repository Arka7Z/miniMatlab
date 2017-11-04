#include "ass4_15CS30003_translator.h"
#include <iostream>
#include <cstring>
#include <string>

extern FILE *yyin;
extern vector<string> allstrings;

using namespace std;

int labelCount=0;							// Label count in asm file
std::map<int, int> labelMap;				// map from quad number to label number
ofstream out;								// asm file stream
vector <quad> array;						// quad array
string asmfilename="ass4_15CS30003_";		// asm file name
string inputfile="ass4_15CS30003_test";		// input file name


void computeActivationRecord(symbolTable* st) {
	int param = -20;
	int local = -24;
	for (list <symb>::iterator it = st->table.begin(); it!=st->table.end(); it++) {
		if (it->category =="param") {
			st->ar [it->name] = param;
			param +=it->size;
		}
		else if (it->name=="return") continue;
		else {
			st->ar [it->name] = local;
			local -=it->size;
		}
	}
}



void genasm() {
	array = quadArray.array;

	//To update the goto labels
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++) {
	int i;
	if (it->op==GOTOOP || it->op==LT || it->op==GreaterThan || it->op==LE|| it->op==GREATERTHANEQ || it->op==EQOP || it->op==NEOP) {
		i = atoi(it->result.c_str());
		labelMap [i] = 1;
	}
	}
	int count = 0;
	for (std::map<int,int>::iterator it=labelMap.begin(); it!=labelMap.end(); ++it)
		it->second = count++;
	list<symbolTable*> tablelist;
	for (list <symb>::iterator it = globalSymbolTable->table.begin(); it!=globalSymbolTable->table.end(); it++) {
		if (it->nest!=NULL) tablelist.push_back (it->nest);
	}
	for (list<symbolTable*>::iterator iterator = tablelist.begin();
		iterator != tablelist.end(); ++iterator) {
		computeActivationRecord(*iterator);
	}

	//asmfile
	ofstream asmfile;
	asmfile.open(asmfilename.c_str());

	asmfile << "\t.file	\"test.c\"\n";
	for (list <symb>::iterator it = table->table.begin(); it!=table->table.end(); it++) {
		if (it->category!="function") {
			if (it->type->cat==_CHAR) { // Global char
				if (it->init!="") {
					asmfile << "\t.globl\t" << it->name << "\n";
					asmfile << "\t.type\t" << it->name << ", @object\n";
					asmfile << "\t.size\t" << it->name << ", 1\n";
					asmfile << it->name <<":\n";
					asmfile << "\t.byte\t" << atoi( it->init.c_str()) << "\n";
				}
				else {
					asmfile << "\t.comm\t" << it->name << ",1,1\n";
				}
			}
			if (it->type->cat==_INT)
			{ // Global int
				if (it->init!="") {
					asmfile << "\t.globl\t" << it->name << "\n";
					asmfile << "\t.data\n";
					asmfile << "\t.align 4\n";
					asmfile << "\t.type\t" << it->name << ", @object\n";
					asmfile << "\t.size\t" << it->name << ", 4\n";
					asmfile << it->name <<":\n";
					asmfile << "\t.long\t" << it->init << "\n";
				}
				else {
					asmfile << "\t.comm\t" << it->name << ",4,4\n";
				}
			}
			if (it->type->cat==_DOUBLE)
			{ // Global int
				if (it->init!="")
				{
					asmfile << "\t.globl\t" << it->name << "\n";
					asmfile << "\t.data\n";
					asmfile << "\t.align 8\n";
					asmfile << "\t.type\t" << it->name << ", @object\n";
					asmfile << "\t.size\t" << it->name << ", 8\n";
					asmfile << it->name <<":\n";
					double d_tmp = atof(it->init.c_str());
					d_util d_bytes;
					d_bytes.d_value=d_tmp;

					asmfile << "\t.long\t" << d_bytes.d_ar[0] << "\n";
					asmfile << "\t.long\t" << d_bytes.d_ar[1] << "\n";
					it->is_global=true;
				}
				else
				{
					asmfile << "\t.comm\t" << it->name << ",4,4\n";
				}

			}

		}
	}
	if (allstrings.size())
	{
		asmfile << "\t.section\t.rodata\n";
		for (vector<string>::iterator it = allstrings.begin(); it!=allstrings.end(); it++)
		{
			asmfile << ".LC" << it - allstrings.begin() << ":\n";
			asmfile << "\t.string\t" << *it << "\n";
		}
	}
	asmfile << "\t.text	\n";

	vector<string> params;
	vector<typeEnum> type_vec;
	std::map<string, int> theMap;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++) {
		if (labelMap.count(it - array.begin())) {
			asmfile << ".L" << (2*labelCount+labelMap.at(it - array.begin()) + 2 )<< ": " << endl;
		}

		opTypeEnum op= it->op;
		string result = it->result;
		string arg1 = it->argument1;
		string arg2 = it->argument2;
		string s=arg2;

		if(op==PARAM){
			params.push_back(result);
			type_vec.push_back(table->lookup(result)->type->cat);
		}
		else
		{
			asmfile << "\t";
			// Binary Operations
			if (op==ADD) {
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) {
					asmfile << "addl \t$" << atoi(arg2.c_str()) << ", " << table->ar[arg1] << "(%rbp)";
				}
				else {
					asmfile << "movl \t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
					asmfile << "\tmovl \t" << table->ar[arg2] << "(%rbp), " << "%edx" << endl;
					asmfile << "\taddl \t%edx, %eax\n";
					asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
				}
			}
			else if (op==SUB) {
				asmfile << "movl \t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tmovl \t" << table->ar[arg2] << "(%rbp), " << "%edx" << endl;
				asmfile << "\tsubl \t%edx, %eax\n";
				asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
			}
			else if (op==MULT) {
				asmfile << "movl \t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) {
					asmfile << "\timull \t$" << atoi(arg2.c_str()) << ", " << "%eax" << endl;
					symbolTable* t = table;
					string val;
					for (list <symb>::iterator it = t->table.begin(); it!=t->table.end(); it++) {
						if(it->name==arg1) val=it->init;
					}
					theMap[result]=atoi(arg2.c_str())*atoi(val.c_str());
				}
				else asmfile << "\timull \t" << table->ar[arg2] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
			}
			else if(op==DIVIDE) {
				asmfile << "movl \t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tcltd" << endl;
				asmfile << "\tidivl \t" << table->ar[arg2] << "(%rbp)" << endl;
				asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
			}

			// Bit Operators /* Ignored */
			else if (op==MODULUS)		asmfile << result << " = " << arg1 << " % " << arg2;
			else if (op==XOR)			asmfile << result << " = " << arg1 << " ^ " << arg2;
			else if (op==INCLUSIVEOR)		asmfile << result << " = " << arg1 << " | " << arg2;
			else if (op==BINARYAND)		asmfile << result << " = " << arg1 << " & " << arg2;
			// Shift Operations /* Ignored */
			else if (op==LEFTSHIFT)		asmfile << result << " = " << arg1 << " << " << arg2;
			else if (op==RIGHTSHIFT)		asmfile << result << " = " << arg1 << " >> " << arg2;

			else if (op==EQUAL)	{
				s=arg1;
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag)
					asmfile << "movl\t$" << atoi(arg1.c_str()) << ", " << "%eax" << endl;
				else
					asmfile << "movl\t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
			}
			else if (op==EQUALSTR)	{
				asmfile << "movq \t$.LC" << arg1 << ", " << table->ar[result] << "(%rbp)";
			}
			else if (op==EQUALCHAR)	{
				asmfile << "movb\t$" << atoi(arg1.c_str()) << ", " << table->ar[result] << "(%rbp)";
			}
			// Relational Operations
			else if (op==EQOP) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				asmfile << "\tje .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==NEOP) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjne .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==LT) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjl .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==GreaterThan) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjg .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==GREATERTHANEQ) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjge .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==LE) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjle .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==GOTOOP) {
				asmfile << "jmp .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			// Unary Operators
			else if (op==ADDRESS) {
				asmfile << "leaq\t" << table->ar[arg1] << "(%rbp), %rax\n";
				asmfile << "\tmovq \t%rax, " <<  table->ar[result] << "(%rbp)";
			}
			else if (op==PTRR) {
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				asmfile << "\tmovl\t(%eax),%eax\n";
				asmfile << "\tmovl \t%eax, " <<  table->ar[result] << "(%rbp)";
			}
			else if (op==PTRL) {
				asmfile << "movl\t" << table->ar[result] << "(%rbp), %eax\n";
				asmfile << "\tmovl\t" << table->ar[arg1] << "(%rbp), %edx\n";
				asmfile << "\tmovl\t%edx, (%eax)";
			}
			else if (op==UNARYMINUS) {
				asmfile << "negl\t" << table->ar[arg1] << "(%rbp)";
			}
			else if (op==BINARYNOT)		asmfile << result 	<< " = ~" << arg1;
			else if (op==LNOT)			asmfile << result 	<< " = !" << arg1;
			else if (op==ARRR) {
				int off=0;
				off=theMap[arg2]*(-1)+table->ar[arg1];
				asmfile << "movq\t" << off << "(%rbp), "<<"%rax" << endl;
				asmfile << "\tmovq \t%rax, " <<  table->ar[result] << "(%rbp)";
			}
			else if (op==ARRL) {
				int off=0;
				off=theMap[arg1]*(-1)+table->ar[result];
				asmfile << "movq\t" << table->ar[arg2] << "(%rbp), "<<"%rdx" << endl;
				asmfile << "\tmovq\t" << "%rdx, " << off << "(%rbp)";
			}
			else if (op==_RETURN) {
				if(result!="") asmfile << "movl\t" << table->ar[result] << "(%rbp), "<<"%eax";
				else asmfile << "nop";
			}
			else if (op==PARAM) {
				params.push_back(result);
			}


			else if (op==CALL)
			{
				// Function Table
				symbolTable* t = globalSymbolTable->lookup(arg1)->nest;
				int i,j=0;	// index
				for (list <symb>::iterator it = t->table.begin(); it!=t->table.end(); it++)
				{
					i = distance ( t->table.begin(), it);

					if (it->category== "param")
					{
						if(j==0)
						{
							if(table->lookup(params[i])->category=="temp" && table->search(params[i]) && table->lookup(params[i])->type->cat==PTR)
							{

								///cout<<"here"<<endl;
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_INT)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovl \t" << params[i] << "(%rip), " << "%edi" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_DOUBLE)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovsd \t" << params[i] << "(%rip), " << "%xmm0" << endl;
								asmfile << "\tcvtsd2ss\t" << "%xmm0, " << "%xmm1" <<endl;
								asmfile << "\tmovss\t" << "%xmm1, " << "%xmm0" <<endl;
							}
							else
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
							}
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==1)
						{
							if(table->search(params[i]) && table->lookup(params[i])->type->cat==PTR)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_INT)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << params[i] << "(%rip), " << "%rsi" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_DOUBLE)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovsd \t" << params[i] << "(%rip), " << "%xmm1" << endl;
								asmfile << "\tcvtsd2ss\t" << "%xmm1, " << "%xmm2" <<endl;
								asmfile << "\tmovss\t" << "%xmm2, " << "%xmm1" <<endl;

							}
							else
							{
							asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rsi" << endl;
							}
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==2)
						{
							if(table->search(params[i]) && table->lookup(params[i])->type->cat==PTR)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_INT)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << params[i] << "(%rip), " << "%rdx" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_DOUBLE)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovsd \t" << params[i] << "(%rip), " << "%xmm2" << endl;
								asmfile << "\tcvtsd2ss\t" << "%xmm2, " << "%xmm3" <<endl;
								asmfile << "\tmovss\t" << "%xmm3, " << "%xmm2" <<endl;

							}
							else
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdx" << endl;
							}
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==3)
						{
							asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rcx" << endl;
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else
						{
							asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
						}
					}
					else break;
				}
				params.clear();
				asmfile << "\tcall\t"<< arg1 << endl;
				asmfile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)";
			}

			// else if (op==CALL)
			// {
			// 	// Function Table
			// 	symbolTable* t = globalSymbolTable->lookup(arg1)->nest;
			// 	int i,j=0;	// index
			// 	for (list <symb>::iterator it = t->table.begin(); it!=t->table.end(); it++) {
			// 		i = distance ( t->table.begin(), it);
			// 		if (it->category== "param") {
			// 			if(j==0) {
			// 				asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
			// 			if(type_vec[i]!=_DOUBLE)
			// 				asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
			// 				else
			// 				asmfile << "\tmovss \t" << table->ar[params[i]] << "(%rbp), " << "%xmm0" << endl;
			// 				//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
			// 				j++;
			// 			}
			// 			else if(j==1) {
			// 				asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
			// 				 if(type_vec[i]!=_DOUBLE)
			// 				asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rsi" << endl;
			// 				else
			// 				 asmfile << "\tmovss \t" << table->ar[params[i]] << "(%rbp), " << "%xmm1" << endl;
			//
			// 				j++;
			// 			}
			// 			else if(j==2) {
			// 				asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
			// 				asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdx" << endl;
			// 				//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
			// 				j++;
			// 			}
			// 			else if(j==3) {
			// 				asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
			// 				asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rcx" << endl;
			// 				//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
			// 				j++;
			// 			}
			// 			else {
			// 				asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
			// 			}
			// 		}
			// 		else break;
			// 	}
			// 	params.clear();
			// 	asmfile << "\tcall\t"<< arg1 << endl;
			// 	asmfile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)";
			// }
			//



			else if (op==FUNC)
			{
				asmfile <<".globl\t" << result << "\n";
				asmfile << "\t.type\t"	<< result << ", @function\n";
				asmfile << result << ": \n";
				asmfile << ".LFB" << labelCount <<":" << endl;
				asmfile << "\t.cfi_startproc" << endl;
				asmfile << "\tpushq \t%rbp" << endl;
				asmfile << "\t.cfi_def_cfa_offset 8" << endl;
				asmfile << "\t.cfi_offset 5, -8" << endl;
				asmfile << "\tmovq \t%rsp, %rbp" << endl;
				asmfile << "\t.cfi_def_cfa_register 5" << endl;
				table = globalSymbolTable->lookup(result)->nest;
				asmfile << "\tsubq\t$" << table->table.back().offset+24<< ", %rsp"<<endl;

				//asmfile << "\tsubq\t$" << table->table.back().offset+24+add<< ", %rsp"<<endl;
				// Function Table
				symbolTable* t = table;
				int i=0;
				for (list <symb>::iterator it = t->table.begin(); it!=t->table.end(); it++) {
					if (it->category== "param") {
						if (i==0) {
							asmfile << "\tmovq\t%rdi, " << table->ar[it->name] << "(%rbp)";
							i++;
						}
						else if(i==1) {
							asmfile << "\n\tmovq\t%rsi, " << table->ar[it->name] << "(%rbp)";
							i++;
						}
						else if (i==2) {
							asmfile << "\n\tmovq\t%rdx, " << table->ar[it->name] << "(%rbp)";
							i++;
						}
						else if(i==3) {
							asmfile << "\n\tmovq\t%rcx, " << table->ar[it->name] << "(%rbp)";
							i++;
						}
					}
					else break;
				}
			}
			else if (op==FUNCEND)
			{
				asmfile << "leave\n";
				asmfile << "\t.cfi_restore 5\n";
				asmfile << "\t.cfi_def_cfa 4, 4\n";
				asmfile << "\tret\n";
				asmfile << "\t.cfi_endproc" << endl;
				asmfile << ".LFE" << labelCount++ <<":" << endl;
				asmfile << "\t.size\t"<< result << ", .-" << result;
			}
			else asmfile << "op";
			asmfile << endl;
		}


	}
	asmfile << 	"\t.ident\t	\"Compiled by Arka Pal\"\n";
	asmfile << 	"\t.section\t.note.GNU-stack,\"\",@progbits\n";
	asmfile.close();
}

template<class T>
ostream& operator<<(ostream& os, const vector<T>& v)
{
	copy(v.begin(), v.end(), ostream_iterator<T>(os, " "));
	return os;
}

int main(int ac, char* av[]) {
	inputfile=inputfile+string(av[ac-1])+string(".c");
	asmfilename=asmfilename+string(av[ac-1])+string(".s");
	globalSymbolTable = new symbolTable("Global");
	table = globalSymbolTable;
	yyin = fopen(inputfile.c_str(),"r");
	yyparse();
	globalSymbolTable->computeOffsets();
	globalSymbolTable->print(1);
	quadArray.print();
	genasm();
}
