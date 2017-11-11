#include <stdio.h>
#include "y.tab.h"


 extern FILE *yyin;
 extern FILE *yyout;
 extern int yylex(void);
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
	int token;
	while (token = yylex()) {
		if(token>=258 && token<=280)
			{
				printf("< KEYWORD >\n"); 
			}
		else if(token==281) printf("< IDENTIFIER >\n");
		else if(token==282) printf("< CONSTANT >\n");

		else if(token==283) printf("< STRING_LITERAL >\n");
        else if (token==306)    printf("ERROR\n");
		else 
			{
				printf("< PUNCTUATOR >\n"); 					
			}
	}
}
