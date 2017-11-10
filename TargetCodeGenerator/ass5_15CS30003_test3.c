//test file to check functions and iterations and also some of the
//functions created in assignment 2

int printInt(int num);
int printStr(char * c);
int printFlt(double f);
int readFlt(double *f);
int readInt(int *t);


int fib(int a){
  //printStr("Entered the fib function\n");
  int f=1,f_1=0;
  int i=1,temp;
  while(i<a) {
    temp=f;
    f=f+f_1;
    f_1=temp;
    i=i+1;
  }
  printStr("The fibonacci number is : ");
  printInt(f);
  return f;
}

int main () {
  printStr("Enter the i for finding its fibonacci number : ");
  int i,ep;
  readInt(&i);
  printStr("You Entered : ");
  printInt(i);

  // printStr("Now, entering the function to calculate fibonacci numbers for i entered\n");
  int j;
   j=fib(i);
  printStr("Returned from the fib function which uses a for loop for calculation");
  return;
}

// test functions
