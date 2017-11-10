//This test file extensively checks the expressions both boolean and algebraic


int printInt(int num);
int printStr(char * c);
int printFlt(double f);
int readFlt(double *f);
int readInt(int *t);

int max (int a, int b) {
  int ans;
  if(a>b){
    ans=a;
  }
  else{
    ans=b;
  }
  return ans;
}
int main () {
  int c = 2, d;
  int x, y, z;
  printStr("Enter two numbers for calculating there maximum :\n");
  printStr("Enter the number 1: ");
  readInt(&x);
  printStr("Enter the number 2: ");
  readInt(&y);
  z = max(x,y);
  printStr("Max is equal to :");
  printInt(z);

  return c;
}
