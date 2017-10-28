

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);


int main()
{
    int a,b;
    a=56;

    printStr("HEllo\n");
    printStr("Enter an integer\n");
    readInt(&a);
    printStr("Printing the integer entered:");
    printInt(a);
    printStr("\n");

    return 0;
}
