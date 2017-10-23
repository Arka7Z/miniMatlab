//This testfile checks the functioning of the library functions printi, readi and prints

int printi(int num);
int prints(char * c);
int readi(int *eP);


int main()
{
    int a,b;
    a=56;
    
    prints("***********************Some random outputs!!*************************\n");
    
    b = 3;
    prints("Passing pointers to function f!\n");
    prints("Value passed to function: ");
    printi(b);
    prints("\n");
    
    prints("Value returned from function s is: ");
    printi(a);
    prints("\n");
    
    prints("Read an integer!!");
    prints("\n");
    prints("The integer that was read is:");
    printi(b);
    prints("\n");
    

    return 0;
}