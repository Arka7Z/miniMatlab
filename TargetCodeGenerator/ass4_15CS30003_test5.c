int printStr(char *c);
int printInt(int i);

int inc(int a,int b){
  printStr("\n\nEntered the function \n");
  b=b+5+a;
  printStr("Value to be returned is : ");
  printInt(b);
  return b;
}

int main() {
  int i,j=10;
  i=1;
  printStr("Entering the function inc... \n");
  j=inc(i,j);
  printStr("\n\nThe value returned from the function is \n");
  printInt(j);
  printStr("\n");
  return 0;
}