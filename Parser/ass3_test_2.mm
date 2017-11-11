// Assignment3 - Test File 2
// Program to find Deteminant of a matrix
  
void getCofactor(Matrix mat, Matrix temp, int p, int q, int N)
{
    int i = 0, j = 0, row, col;
 
    for (row = 0; row < n; row++)
    {
        for (col = 0; col < n; col++)
        {
            if (row != p && col != q)
            {
                temp[i][j++] = mat[row][col];
 
                if (j == n - 1)
                {
                    j = 0;
                    i++;
                }
            }
        }
    }
}
 
/* Recursive function for finding determinant of matrix.
   n is current dimension of mat[][]. */
float determinantOfMatrix(Matrix mat, int N)
{
    float D = 0.0; // Initialize result
 
    if (N == 1)
        return mat[0][0];
 
    Matrix temp[N][N];
 
    int sign = 1;

    int f;
    for (f = 0; f < N; f++)
    {
        getCofactor(mat, temp, 0, f, N);
        D += sign * mat[0][f] * determinantOfMatrix(temp, N - 1);

        sign = -sign;
    }
    return D;
}
 
/* function for displaying the matrix */
void display(Matrix mat, int row, int col)
{
    int i, j;
    for (i = 0; i < row; i++)
    {
        for (j = 0; j < col; j++)
            printFlt(mat[i][j]);
        printStr("\n");
    }
}
 
int compute_determinant()
{
    Matrix mat1[4][4] = {1.3, 0.1, 2.5, -1; 3, 0, 0.6, 5;2, 1.8, 4, -3;1, 0.3, 5, 0.9};
    Matrix mat2[4][4] = {2.3, 1.1, 3.5, -2; 4, 1, 1.6, 6;1, 0.8, 3, -2;2, 2.3, 7, 2.9};

    Matrix mat[4][4];

    mat = mat1 * mat2;

    mat = mat + mat1;

    mat = mat - mat2.';

    printStr("Determinant of the matrix is\n");
    printFlt(determinantOfMatrix(mat, 4));
    return 0;
}