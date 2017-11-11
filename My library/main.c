#include "myl.h"
#include <stdio.h>
int main()
{
	/*float f;
	printStr("enter float\n\0") ;
	readFlt(&f);
	printf("%d float return \n",readFlt(p ));
	printf("float through printf %f \n",f);
	printf("%d \n",printFLT(f ));
	*/int n;
	int* np;
	np=&n;
	printStr("enter int\n\0") ;
	printf("%d int return\n",readInt(np) );
	printf("%d print int return\n",printInt(n));
	char* str="0123  \n\0";
	printf("%d printstr return\n",printStr(str) );
	printf("hello out\n");
	return 0;
}

