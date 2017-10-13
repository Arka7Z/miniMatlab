// Checking Matrix Operations
void main()
{

	Matrix m[2][3]={1.3,2.0,3.2;4.0,5.6,4.5};
	double f=4.5;
	m=-m;
 	Matrix z[2][3];

	z=m-f;

	z=m*f;


	Matrix y[3][2];
	y=m.';
	Matrix x[3][3];
	x=y*z;
	z=f*m+m*x;


}
