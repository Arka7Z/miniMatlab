#include "ass5_15CS30003_translator.h"
#include <iostream>
#include <cstring>
#include <string>

extern FILE *yyin;
extern vector<string> allstrings;
extern vector<init_double> alldoubles;

using namespace std;

ofstream out;								// asm file stream

string asmfilename="ass5_15CS30003_";		// asm file name

string globlName;
string CurrName;

bool debug=false;
vector <quad> array;						// quad array
int labelCount=0;							// Label count in asm file

std::map<int, int> labelMap;				// map from quad number to label number

string globalName;

string inputfile="ass5_15CS30003_test";		// input file name


void computeActivationRecord(symbolTable* st)
{
	int init=20;
	int param =-(init);
	int local = param-4;
	traverse2(st->table,it)
	{

		if (it->category =="param")
		{
			st->ar [it->name] = param;
			int currentSize=it->size;
			param +=currentSize;
		}
		else if (it->name=="return")
				continue;

		else
		{
			if(it->type->cat==_MATRIX )
			{
				st->ar[it->name]=local-it->size+8;
				int currentSize=it->size;
				local -= currentSize;

			}
			else
			{
			st->ar [it->name] = local;
			int currentSize=it->size;
			local -=currentSize;
			}
		}
	}

}

void setTrue(bool& x)
{
		x=true;
}
void setFalse(bool& x)
{
		x=false;
}

void genasm() {

	int lineNum=0;
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;;
	}
	array = quadArray.array;

	traverse2(array,it)
	{
	int i;
	int one=1;
	opTypeEnum op=it->op;
				if (op==GOTOOP || op==LT || op==GreaterThan)
				{
					i = atoi(it->result.c_str());
					labelMap [i] = one;
				}
				if ( op==LE|| op==GREATERTHANEQ || op==EQOP || op==NEOP)
				{
					i = atoi(it->result.c_str());
					labelMap [i] = one;
				}
	}
	int count;
	count=0;
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;;
	}

	traverse2(labelMap,it)
		it->second = count++;


	list<symbolTable*> tablelist;

	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;
	}
	traverse2(globalSymbolTable->table,it)
	{
		if(! (it->nest==NULL))
		 tablelist.push_back (it->nest);
	}



		traverse2(tablelist,it)
	{
		computeActivationRecord(*it);
	}

	//asmfile
	ofstream asmfile;
	asmfile.open(asmfilename.c_str());
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;
	}

	asmfile << "\t.file	\"TEST.c\"\n";



	int global_double_count=0;


string globl="\t.globl\t";

	traverse2(table->table,it)
	 {
		if (it->category!="function")


		{

				if (debug)
					cout<<"140"<<endl;
			typeEnum category=it->type->cat;
			switch (category)
			{
														case _CHAR:

														{
															if (it->init!="")
															 {
																asmfile << globl << it->name << "\n";
																asmfile << "\t.type\t" << it->name << ", @object\n";
																asmfile << "\t.size\t" << it->name << ", 1\n";
																asmfile << it->name <<":\n";
																asmfile << "\t.byte\t" << atoi( it->init.c_str()) << "\n";
															}
															else {
																asmfile << "\t.comm\t" << it->name << ",1,1\n";
															}
														}
														break;


														case _INT:
														{ // Global int
															if (it->init!="") {
																asmfile << globl << it->name << "\n";
																asmfile << "\t.data\n";
																if (debug)
																	cout<<"168"<<endl;
																asmfile << "\t.align 4\n";
																if (debug)
																	cout<<"171"<<endl;
																asmfile << "\t.type\t" << it->name << ", @object\n";
																asmfile << "\t.size\t" << it->name << ", 4\n";
																if (debug)
																	cout<<"175"<<endl;
																asmfile << it->name <<":\n";
																if (debug)
																	cout<<"178"<<endl;
																asmfile << "\t.long\t" << it->init << "\n";
																if (debug)
																	cout<<"181"<<endl;
															}
															else {
																asmfile << "\t.comm\t" << it->name << ",4,4\n";
															}
														}
														break;


														case _DOUBLE:
														{ // Global int
															if (it->init!="")
															{
																asmfile << globl << it->name << "\n";
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

																global_double_count++;
															}


															else
															{
																asmfile << "\t.comm\t" << it->name << ",4,4\n";
															}

														}
														break;
														default: break;

															}
		}
	}

						string newline("\n");
						int two=2;
						global_double_count=global_double_count/two;
						if (allstrings.size()+alldoubles.size()-global_double_count)
						{
										asmfile << "\t.section\t.rodata\n";
										traverse2(allstrings,it)
										{
											if (debug)
											{
												cout<<lineNum<<endl;
												lineNum++;
											}

											asmfile << ".LC" << it - allstrings.begin() << ":\n";
											string String_name("\t.string\t" );
											if (debug)
											{
												cout<<lineNum<<endl;
												lineNum++;
											}
											asmfile <<String_name << *it << "\n";
										}

										typeof(alldoubles.begin()) it2 = alldoubles.begin();
										if (debug)
										{
											cout<<lineNum<<endl;
											lineNum++;
										}
										it2 +=global_double_count;
										if (debug)
										{
											cout<<lineNum<<endl;
											lineNum++;
										}
										for(;it2!=alldoubles.end();it2++)
										{
											//if(!it->is_global)
											//{
												asmfile << "\t.align 8" << endl;
												if (debug)
												{
													cout<<lineNum<<endl;
													lineNum++;
												}
												asmfile << ".LC" << it2->name << ":\n";
												d_util d_bytes;
												double val=it2->d_value;
												if (debug)
												{
													cout<<lineNum<<endl;
													lineNum++;
												}
												d_bytes.d_value=val;
												if (debug)
												{
													cout<<lineNum<<endl;
													lineNum++;
												}
												asmfile << "\t.long\t" << d_bytes.d_ar[0] <<newline;
												if (debug)
												{
													cout<<lineNum<<endl;
													lineNum++;
												}
												asmfile << "\t.long\t" << d_bytes.d_ar[1] <<newline;
											//}
										}
						}


	asmfile << "\t.text	\n";

	vector<string> params;
	string Movl("\tmovl\t");
	string Rbp("(%rbp)");
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;
	}
	vector<typeEnum> type_vec;
	std::map<string, int> theMap;
	traverse2(array,it)
	{
		if (labelMap.count(it - array.begin()))
		{

			asmfile << ".L" << (two*labelCount+labelMap.at(it - array.begin()) + two )<< ": " << endl;
		}

		opTypeEnum op= it->op;
		if (debug)
		{
			cout<<lineNum<<endl;
			lineNum++;
		}


		string result = it->result;
		if (debug)
		{
			cout<<lineNum<<endl;
			lineNum++;
		}
		string arg1 = it->argument1;
		if (debug)
		{
			cout<<lineNum<<endl;
			lineNum++;
		}
		string arg2 = it->argument2;
		if (debug)
		{
			cout<<lineNum<<endl;
			lineNum++;
		}
		string s=arg2;

		if(op==PARAM)
		{
			params.push_back(result);
			type_vec.push_back(table->lookup(result)->type->cat);
		}
		else
		{
			asmfile << "\t";
			// Binary Operations
			if (op==ADD)
			{

								if (debug)
									cout<<"280"<<endl;
																					bool flag=true;
																					if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+')))
																								flag=false ;
																					else
																					{
																						char * p ;
																						strtol(s.c_str(), &p, 10) ;
																						if(*p == 0)
																						setTrue(flag) ;
																						else
																						setFalse(flag);
																					}
																					if (flag)
																					{
																						asmfile << "addl \t$" << atoi(arg2.c_str()) << ", " << table->ar[arg1] << "(%rbp)";
																					}
																					else
																					{
																												typeEnum type1=table->lookup(arg1)->type->cat;
																												typeEnum type2=table->lookup(arg2)->type->cat;
																												if(type1==_MATRIX)
																												//case like t1=m+t2 //doesn't calculated the address, just assigns t1=t2 	string Movl("\tmovl\t");
																												{

																													asmfile << Movl<< table->ar[arg2] << "(%rbp), " << "%eax" << endl;
																													//asmfile << "\taddq\t%rdx, %rax"<<endl;
																													asmfile << "\tmovl\t%eax, " << table->ar[result] <<Rbp <<endl;
																												}
																												else if(type1==_DOUBLE && type2==_DOUBLE)
																												{
																													asmfile << "\tmovsd\t" << table->ar[arg1] << "(%rbp), %xmm0" << endl;
																													if (debug)
																													{
																														cout<<lineNum<<endl;
																														lineNum++;
																													}
																													asmfile << "\tmovsd\t" << table->ar[arg2] << "(%rbp), %xmm1" << endl;
																													if (debug)
																													{
																														cout<<lineNum<<endl;
																														lineNum++;
																													}
																													asmfile << "\taddsd\t%xmm0, %xmm1" <<endl;
																													if (debug)
																													{
																														cout<<lineNum<<endl;
																														lineNum++;
																													}
																													asmfile << "\tmovsd\t%xmm1, " << table->ar[result] <<Rbp<<endl;
																												}
																												else
																												{
																													//	string Movl("\tmovl\t");
																													asmfile << Movl << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
																													if (debug)
																													{
																														cout<<lineNum<<endl;
																														lineNum++;
																													}
																													asmfile << Movl << table->ar[arg2] << "(%rbp), " << "%edx" << endl;
																													if (debug)
																													{
																														cout<<lineNum<<endl;
																														lineNum++;
																													}
																													asmfile << "\taddl \t%edx, %eax\n";
																													if (debug)
																													{
																														cout<<lineNum<<endl;
																														lineNum++;
																													}
																													asmfile << "\tmovl \t"<<"%eax, " << table->ar[result] << Rbp<<endl;
																												}
																					}

																									if (debug)
																										cout<<"328"<<endl;
				}

			else if (op==SUB)
			{
				typeEnum type1=table->lookup(arg1)->type->cat;
				typeEnum type2=table->lookup(arg2)->type->cat;
															if(type1==_DOUBLE && type2==_DOUBLE)
																{

																					if (debug)
																						cout<<"339"<<endl;

																	string temp1("(%rbp), %xmm1" );
																	string temp0("(%rbp), %xmm0");
																	asmfile << "\tmovsd\t" << table->ar[arg1] << temp1 << endl;
																	if (debug)
																	{
																		cout<<lineNum<<endl;
																		lineNum++;
																	}
																	asmfile << "\tmovsd\t" << table->ar[arg2] << temp0 << endl;
																	if (debug)
																	{
																		cout<<lineNum<<endl;
																		lineNum++;
																	}
																	asmfile << "\tsubsd\t%xmm0, %xmm1" <<endl;
																	if (debug)
																	{
																		cout<<lineNum<<endl;
																		lineNum++;
																	}
																	asmfile << "\tmovsd\t%xmm1, " << table->ar[result] << Rbp <<endl;
																	if (debug)
																	{
																		cout<<lineNum<<endl;
																		lineNum++;
																	}
																}
															else
															{

																asmfile << "movl \t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
																if (debug)
																{
																	cout<<lineNum<<endl;
																	lineNum++;
																}
																asmfile << "\tmovl \t" << table->ar[arg2] << "(%rbp), " << "%edx" << endl;
																if (debug)
																{
																	cout<<lineNum<<endl;
																	lineNum++;
																}


																				if (debug)
																					cout<<"356"<<endl;
																asmfile << "\tsubl \t%edx, %eax\n";
																if (debug)
																{
																	cout<<lineNum<<endl;
																	lineNum++;
																}
																asmfile << "\tmovl \t%eax, " << table->ar[result] << Rbp<<endl;
																if (debug)
																{
																	cout<<lineNum<<endl;
																	lineNum++;
																}
															}
			}
			else if (op==MULT)
			{
											lineNum=530;
													typeEnum type1=table->lookup(arg1)->type->cat;
													typeEnum type2=table->lookup(arg2)->type->cat;
															if(type1==_DOUBLE && type2==_DOUBLE)
													{
														asmfile << "\tmovsd\t" << table->ar[arg1] << "(%rbp), %xmm0" << endl;
														if (debug)
															cout<<"368"<<endl;
														asmfile << "\tmovsd\t" << table->ar[arg2] << "(%rbp), %xmm1" << endl;
														if (debug)
															cout<<"372"<<endl;
														asmfile << "\tmulsd\t%xmm0, %xmm1" <<endl;
														if (debug)
															cout<<"375"<<endl;
														asmfile << "\tmovsd\t%xmm1, " << table->ar[result] << "(%rbp)" <<endl;
														if (debug)
															cout<<"378"<<endl;
													}
												else
													{
														asmfile << "movl \t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
														bool flag=true;
														if(s.empty() )

														    setFalse(flag) ;
														if (((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+')))
																	 setFalse(flag) ;
														else
														{
															char * p ;
															int ten;
															ten=10;
															strtol(s.c_str(), &p, ten) ;
															if(*p == 0)
																setTrue(flag);
															else
																 setFalse(flag) ;
														}
														if(flag)
														{
																	asmfile << "\timull \t$" << atoi(arg2.c_str()) << ", " << "%eax" << endl;
																	symbolTable* t = table;
																	string val;

																	traverse2(t->table,it)
																	{
																		if(it->name==arg1) val=it->init;
																	}
																	theMap[result]=atoi(arg2.c_str())*atoi(val.c_str());
														}
														else
																	asmfile << "\timull \t" << table->ar[arg2] << "(%rbp), " << "%eax" << endl;
														asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)";
													}
			}
			else if (op==BINARYAND)
							asmfile << result << " = " << arg1 << " & " << arg2;
			else if(op==DIVIDE)
			{
				asmfile <<Movl << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcltd" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tidivl \t" << table->ar[arg2] << Rbp << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovl \t%eax, " << table->ar[result] << "(%rbp)"<<endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}

			// Bit Operators /* Ignored */

			else if (op==XOR)
						asmfile << result << " = " << arg1 << " ^ " << arg2;
			else if (op==MODULUS)
						asmfile << result << " = " << arg1 << " % " << arg2;
			else if (op==EQUALCHAR)	{
				if (debug)
					cout<<"427"<<endl;
							asmfile << "movb\t$" << atoi(arg1.c_str()) << ", " << table->ar[result] << "(%rbp)";
						}

			else if (op==INCLUSIVEOR)
						asmfile << result << " = " << arg1 << " | " << arg2;

			else if(op==EQUAL_DOUBLE)
			{
				asmfile << "movq\t" <<".LC"<< result << "(%rip), " << "%rax" << endl;
				asmfile << "\tmovq \t%rax, " << table->ar[result] << "(%rbp)";
			}
			// Shift Operations /* Ignored */
			else if (op==LEFTSHIFT)		asmfile << result << " = " << arg1 << " << " << arg2;
			else if (op==RIGHTSHIFT)		asmfile << result << " = " << arg1 << " >> " << arg2;

			else if (op==EQUAL)
			{				if(table->lookup(arg1)->type->cat==_MATRIX && table->lookup(result)->type->cat==_MATRIX)
				{

					if(table->lookup(result)->size > table->lookup(arg1)->size)
					{
						table->lookup(arg1)->size = table->lookup(result)->size;
					}
					else if(table->lookup(result)->size < table->lookup(arg1)->size)
					{
						table->lookup(result)->size = table->lookup(arg1)->size;
					}
					for(int ii=0;ii<max(table->lookup(result)->size,table->lookup(arg1)->size);ii+=8)
					{
						asmfile <<"\tmovq\t" << table->ar[arg1]+ii << "(%rbp), %rax" << endl;
						asmfile <<"\tmovq\t" << "%rax, " << table->ar[result]+ii << "(%rbp)" <<endl;

										if (debug)
											cout<<"456"<<endl;
					}
				}
				else
				{
						s=arg1;
						bool flag=true;
						if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+')))
							flag=false ;
						else
						{

											if (debug)
												cout<<"466"<<endl;
							char * p ;
							strtol(s.c_str(), &p, 10) ;
							if(*p == 0)
								setTrue(flag);
							else
								setFalse(flag);
						}
						if(flag)
						{
							asmfile << "movl\t$" << atoi(arg1.c_str()) << ", " << "%eax" << endl;


											if (debug)
												cout<<"483"<<endl;
							asmfile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)" << endl;
						}
						else
						{
							if(table->lookup(result)->type->cat==PTR)
							{
								if(table->lookup(result)->type->ptr!=NULL && table->lookup(result)->type->ptr->cat==_CHAR)
								{
									asmfile << "movq\t" << table->ar[arg1] << "(%rbp), " << "%rax" << endl;

													if (debug)
														cout<<"495"<<endl;
									asmfile << "\tmovq\t%rax, " << table->ar[result] << "(%rbp)"<<endl;
								}
								else
								{
									asmfile << "movl\t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;

													if (debug)
														cout<<"503"<<endl;
									asmfile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)"<<endl;
								}
							}
							else if(table->lookup(result)->type->cat==_DOUBLE)
							{
								asmfile << "movq\t" << table->ar[arg1] << "(%rbp), " << "%rax" << endl;
								asmfile << "\tmovq\t%rax, " << table->ar[result] << "(%rbp)"<<endl;
							}
							else
							{
								asmfile << "movl\t" << table->ar[arg1] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)"<<endl;
							}
						}


						if((globalSymbolTable->search(result) && globalSymbolTable->lookup(result)->is_global))
						{
							asmfile << "\tmovq\t%rax, " << result << "(%rip)";
							globalSymbolTable->lookup(result)->re_init=true;
						}

				}

			}
			else if (op==GREATERTHANEQ) {
				lineNum=731;
				asmfile << Movl << table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tjge .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}

			else if (op==LE) {
				asmfile << Movl << table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tjle .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}

			else if (op==EQUALSTR)
			{
				asmfile << "movq \t$.LC" << arg1 << ", " << table->ar[result] << "(%rbp)";
			}

			// Relational Operations

			else if (op==NEOP) {
				asmfile << Movl<< table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tjne .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}
			else if (op==LT) {
				asmfile << Movl << table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tjl .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}
			else if (op==GreaterThan) {
				asmfile << Movl << table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tjg .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}

			else if (op==GOTOOP)
			 {
				asmfile << "jmp .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}
			// Unary Operators
			else if (op==ADDRESS) {
				asmfile << "leaq\t" << table->ar[arg1] << "(%rbp), %rax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovq \t%rax, " <<  table->ar[result] << "(%rbp)";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}
			else if (op==PTRR) {
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovl\t(%eax),%eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovl \t%eax, " <<  table->ar[result] << "(%rbp)";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}
			else if (op==PTRL) {
				asmfile << "\tmovl\t" << table->ar[result] << "(%rbp), %eax\n";
				asmfile << "\tmovl\t" << table->ar[arg1] << "(%rbp), %edx\n";
				asmfile << "\tmovl\t%edx, (%eax)";
			}
			else if (op==UNARYMINUS) {
				asmfile << "negl\t" << table->ar[arg1] << "(%rbp)";
			}
			else if (op==BINARYNOT)		asmfile << result 	<< " = ~" << arg1;
			else if (op==LNOT)			asmfile << result 	<< " = !" << arg1;

			else if (op==ARRR)
			{
				int off=0;
				off=theMap[arg2]*(-1)+table->ar[arg1];

				asmfile << "leaq\t" << table->ar[arg1] << "(%rbp), " << "%rdx" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovl\t" << table->ar[arg2] << "(%rbp), %eax" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}

				asmfile << "\tmovq\t(%rdx,%rax), %rax" <<endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovq\t%rax, " << table->ar[result] <<"(%rbp)"<<endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}

			}
			else if (op==ARRL)
			{
				int off=0;
				off=theMap[arg1]*(-1)+table->ar[result];
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}

				asmfile << "movl\t" << table->ar[arg1] << "(%rbp), "<<"%eax" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tleaq\t" << table->ar[result] << "(%rbp), " << "%rdx" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tleaq\t(%rdx,%rax), %rax" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovq\t" << table->ar[arg2] << "(%rbp), %rdx" << endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tmovq\t%rdx, (%rax)" <<endl;
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}




			}
			else if (op==EQOP)
			{
				asmfile << Movl << table->ar[arg1] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tcmpl\t" << table->ar[arg2] << "(%rbp), %eax\n";
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				asmfile << "\tje .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
			}
			else if(op==INIT_MAT)
{
	string movq( "\tmovq\t" );
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;
	}
	asmfile << movq << table->ar[arg2] << "(%rbp), %rdx" << endl;
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;
	}
	asmfile <<movq<<"%rdx, " << table->ar[result]+atoi(arg1.c_str()) << Rbp << endl;
	if (debug)
	{
		cout<<lineNum<<endl;
		lineNum++;
	}
}

			else if (op==_RETURN)
			{
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
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
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				int i,j=0;	// index
				if (debug)
				{
					cout<<lineNum<<endl;
					lineNum++;
				}
				for (list <symb>::iterator it = t->table.begin(); it!=t->table.end(); it++)
				{
					i = distance ( t->table.begin(), it);

					if (it->category== "param")
					{
						if(j==0)
						{
							if(table->search(params[i]) && table->lookup(params[i])->type->cat==_DOUBLE)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								// cout<<"IN DOUBLE"<<endl;
								asmfile << "\tmovsd \t" << table->ar[params[i]] << "(%rbp), " << "%xmm0" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tcvtsd2ss\t" << "%xmm0, " << "%xmm0" <<endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								//asmfile << "\tmovss\t" << "%xmm0, " << "%xmm0" <<endl;

							}
							else if(table->lookup(params[i])->category=="temp" && table->search(params[i]) && table->lookup(params[i])->type->cat==PTR)
							{
								///cout<<"here"<<endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_INT)
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;

												if (debug)
													cout<<"676"<<endl;
								asmfile << "\tmovl \t" << params[i] << "(%rip), " << "%edi" << endl;

												if (debug)
													cout<<"680"<<endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_DOUBLE)
							{
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovsd \t" << params[i] << "(%rip), " << "%xmm0" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tcvtsd2ss\t" << "%xmm0, " << "%xmm0" <<endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}

							}
							else
							{
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}

							}
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==1)
						{

											if (debug)
												cout<<"698"<<endl;
							string mo("\tmovl \t" );
							if(table->search(params[i]) && table->lookup(params[i])->type->cat==PTR)
							{
								asmfile << mo << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;

												if (debug)
													cout<<"705"<<endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;

												if (debug)
													cout<<"709"<<endl;

							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_INT)
							{
								asmfile << mo << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;

												if (debug)
													cout<<"717"<<endl;
								asmfile << "\tmovq \t" << params[i] << "(%rip), " << "%rsi" << endl;

												if (debug)
													cout<<"721"<<endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_DOUBLE)
							{
								asmfile <<mo << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								asmfile << "\tmovsd \t" << params[i] << "(%rip), " << "%xmm1" << endl;

												if (debug)
													cout<<"729"<<endl;
								asmfile << "\tcvtsd2ss\t" << "%xmm1, " << "%xmm1" <<endl;

												if (debug)
													cout<<"733"<<endl;
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;

												if (debug)
													cout<<"737"<<endl;

							}
							else
							{
														asmfile <<mo << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
														if (debug)
														{
															cout<<lineNum<<endl;
															lineNum++;
														}
														asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rsi" << endl;
														if (debug)
														{
															cout<<lineNum<<endl;
															lineNum++;
														}
														asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
														if (debug)
														{
															cout<<lineNum<<endl;
															lineNum++;
														}
							}
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==2)
						{
							if(table->search(params[i]) && table->lookup(params[i])->type->cat==PTR)
							{
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_INT)
							{
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << params[i] << "(%rip), " << "%rdx" << endl;
							}
							else if(globalSymbolTable->lookup(params[i])->is_global && globalSymbolTable->lookup(params[i])->type->cat==_DOUBLE)
							{
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovsd \t" << params[i] << "(%rip), " << "%xmm2" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}

								asmfile << "\tcvtsd2ss\t" << "%xmm2, " << "%xmm2" <<endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;

							}
							else
							{
								asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdx" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
								asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
								if (debug)
								{
									cout<<lineNum<<endl;
									lineNum++;
								}
							}
							//asmfile << "\tmovl \t%eax, " << (t->ar[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==3)
						{
							asmfile << "movl \t" << table->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rcx" << endl;

							j++;
						}
						else
						{
							asmfile << "\tmovq \t" << table->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
						}
					}
					else
						break;
				}
				params.clear();
				asmfile << "\tcall\t"<< arg1 << endl;
				asmfile << "\tmovl\t%eax, " << table->ar[result] << "(%rbp)";
			}




			else if (op==FUNC)
			{
				asmfile <<".globl\t" << result << endl;
				asmfile << "\t.type\t"	<< result << ", @function\n";

								if (debug)
									cout<<"784"<<endl;
				asmfile << result << ": \n";

								if (debug)
									cout<<"788"<<endl;
				asmfile << ".LFB" << labelCount <<":" << endl;

								if (debug)
									cout<<"792"<<endl;
				asmfile << "\t.cfi_startproc" << endl;

								if (debug)
									cout<<"796"<<endl;
				asmfile << "\tpushq \t%rbp" << endl;

								if (debug)
									cout<<"800"<<endl;
				asmfile << "\t.cfi_def_cfa_offset 8" << endl;

								if (debug)
									cout<<"804"<<endl;
				asmfile << "\t.cfi_offset 5, -8" << endl;
				asmfile << "\tmovq \t%rsp, %rbp" << endl;

				if (debug)
					cout<<"809"<<endl;

				asmfile << "\t.cfi_def_cfa_register 5" << endl;
				table = globalSymbolTable->lookup(result)->nest;
				asmfile << "\tsubq\t$" << table->table.back().offset+24<< ", %rsp"<<endl;
				int i;

				symbolTable* t = table;

				i=0;

				traverse2(t->table,it)
				{
									if (it->category== "param")
									{

															if (i==0)
															{

																asmfile << "\tmovq\t%rdi, " << table->ar[it->name] << "(%rbp)";
																i=i+1;
															}
															else if(i==1)
															 {
																asmfile << "\n\tmovq\t%rsi, " << table->ar[it->name] << "(%rbp)";
																i=i+1;
															}
															else if (i==2)
															{
																asmfile << "\n\tmovq\t%rdx, " << table->ar[it->name] << "(%rbp)";
																i=i+1;
															}
															else if(i==3)
															{
																asmfile << "\n\tmovq\t%rcx, " << table->ar[it->name] << "(%rbp)";
																i=i+1;
															}
									}
									else
					 							break;
				}
			}
			// else if (op==ZERO)
			// {
			// 	asmfile<<"movq\t$0"<<table->ar[result]<< " (%rbp)";
			//
			// }
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
			else {
				asmfile << "op";

			}
			asmfile << endl;
		}


	}
	string ident("\t.ident\t	\"Compiled by Arka Pal\"\n");
	asmfile << ident;
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
	quadArray.printtab();
	quadArray.print();
	genasm();
}
