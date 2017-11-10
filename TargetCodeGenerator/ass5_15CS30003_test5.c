// the test file for testing some of matrix operations
int printInt(int num);
int printStr(char * c);
int printFlt(double f);
int readFlt(double *f);
int readInt(int *t);

void main()
{
  printStr("the test file for testing some of matrix operations\n\n");
  int i=0,j;
//  Matrix m[2][2]={1.2,2.3;2.5,1.3};
    Matrix m[2][2]={1.3,1.4;1.5,2.1};
  Matrix y[2][2];
    Matrix z[2][2];
  printStr("What is being done is we declared the matrix m and assigned it to a new matrix y as y=m\n");
  y=m;
  z=m;
  printStr("Printing y in row major order\n");
    int j=0;
    for (i=0;i<2;i++)
    for(j=0;j<2;j++)
    {
  printFlt(y[i][j]);
    }
    printStr("Now let us square y as in y=y*y\n");
    y=z*m;
      printStr("Printing y in row major order\n");
      double d;
    for (i=0;i<2;i++)
    for(j=0;j<2;j++)
    {


      printFlt(y[i][j]);
    }

}
