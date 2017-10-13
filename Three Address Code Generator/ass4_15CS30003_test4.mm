// Checking statetements
void main()
{

	int i=2;
	double v=3.4;
	Matrix m[2][2] = {1.2,2.0;3.5,4.3};

	while(m[i][i]<v)
   i=i-1;
	Matrix x[2][2];
	x=m;
	int j;
	for(j=0;j<3;j++)
	{
		x=x+m;
	}
	m[1][1]=5.6;


}

