#include <stdio.h>
#include "y.tab.h"


 extern FILE *yyin;
 extern FILE *yyout;
 extern int yyparse (void);
 extern char *yytext;



int main(int argc,char** argv)
{

	if (argc > 1)
	{
		FILE *file;
		file = fopen(argv[1], "r");
		if (!file)
		{
    		fprintf(stderr, "Could not open %s\n", argv[1]);
    		return 0;
		}
		yyin = file;
	}
	if(yyparse()==0)
		printf("%s",yytext);
}

