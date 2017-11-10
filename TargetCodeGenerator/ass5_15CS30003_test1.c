
//This testfile checks the functioning of the library functions printi, readi and prints
int printInt(int num);
int printStr(char * c);
int printFlt(double f);
int readFlt(double *f);
int readInt(int *t);
// Test Declaration
double d = 2.3;
Matrix m[2][3];
int a = 4, *p, b;
void func(int i, double d,Matrix a[2][2]);
char c;

int main ()
{
  double e = 2.3;
  int f;
  Matrix temp[2][2] = {1.1,2.1;3.3,3.4};
  printStr("Checking printFlt and Matrix initialization : ");
  printFlt(temp[1][1]);
  printStr("\n");
  int r = 4, *q, y;
  printStr("The value of global double d :");
  printFlt(d);
  printStr("\n");
  printStr("checking printInt and readInt:\n");
  printStr("Enter an integer N: ");
  readInt(&r);
  
  printStr("The value of N is : ");
  printInt(r);

}
