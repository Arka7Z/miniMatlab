// Assignment3 - Test File 1
// Check All Keywords and Operations
void keywords_and_op_check() {

  unsigned int num = 10;
  signed int i;
  Bool B = 1;


  char * s1 = 'comp';
  char * s2 = "parse";

  switch (x) {
  case 1:
    a = 1;
    break;
  case 2:
    a = 2;
    break;
  case 3:
    a = 3;
    break;
  default:
    a = 1;
  }

  float f1 = 1.2e3;
  float f2 = -2E-2;

  short int d = 4;

  char c_c = 'a';

  for (i = 1;
    (i < num) && (num != 1); ++i) {
    A[i] = i;
    if (i >= 1)
      continue;
    else
      break;
  }

  for (;;) {
    b = 5;
  }

  if (i == 9)
    i = i % 11;
  else if (i >= 11)
    i %= 5;

  i = num - i;
  do {
    a++;
    b--;
    c+=a;
    i--;
  } while (i != 1 || (num != 1));

  a = b + c;
  b = c * a;
  c = a / b;
  a = c/2;

  b -= 5;
  c /= 10;

  c = c ^ b;
  b = b | d;
  a ^= d;
  c |= d;
  b &= d;
  return;
}
