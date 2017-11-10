// the test file for testing some of matrix initialization and readflt and printflt and a few matrix operations
int printInt(int num);
int printStr(char * c);
int printFlt(double f);
int readFlt(double *f);
int readInt(int *t);

void main(){
  printStr("the test file for testing some of matrix  initialization and readflt and printflt\n\n");
  int i,j;
    Matrix n[2][2]={2.0,1.3;3.4,5.5};
  Matrix m[2][2]={1.0,2.3;3.4,4.5};
  Matrix x[2][2],y[2][2];

  x=m+n;
  y=m-x;
printStr("Matrix addition demo\n");
 for(i=0;i<2;i++)
 for(j=0;j<2;j++)
 printFlt(x[i][j]);

 printStr("Matrix subtraction demo\n");
 for(i=0;i<2;i++)
 for(j=0;j<2;j++)
 printFlt(y[i][j]);

  double d;

}
