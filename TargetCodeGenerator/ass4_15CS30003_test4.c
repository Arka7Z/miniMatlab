//test file to check basic statements, expression, readInt and printInt library 
//functions created in assignment 2
//also checks the recursive fibonacci function to check the function call and return methodology


int printStr(char *c);
int printInt(int i);
int readInt(int *eP);


int fib(int a){
  printStr("\nEntered the function for i : ");
  printInt(a);
  int b=a-1,c,d;
  if(b<=0) return 1;
  else {
    c=fib(b);
    b=b-1;
    d=fib(b);
    c=c+d;
    return c;
  }
  return 1;
}

int main () {
  int a = 5, b = 2, c;
  char ch = 'x';
  char* str;
  str = "Hello World\n";
  char* str1;
  str1 = "abcd";
  int read;
  read = 5;
  int eP;
  if (a<b) {
    a++;
  }
  else {
    c = a+b;
  }
  printStr("Please enter a number for recursive fibonacci: ");
  read = readInt(&eP);
  printStr("You Entered ");
  c = printInt(read);
  printStr("\n");

  printStr("Now testting for recursive fibonacci number ....Entering the function\n");
  int out=0;
  out=fib(read);
  printStr("\n\nReturned from recursive fibonacci function");

}