#include <stdio.h>
#include <stdlib.h>

int read_num(char num[], int start, int end) {
  int res = 0;
  int digit = 1;
  for (int i = end - 1; i > start; i--) {
    res += (num[i] - 48) * (digit);
    digit *= 10;
  }
  if (num[start] == '-') {
    return -res;
  }
  return res;
}

void pack(int input, int start, int end, int *val) {
  int lsb = end - start;
  int mask = 1;
  for (int i = 0; i < lsb; i++) {
    mask *= 2;
    mask += 1;
  }
  int temp = mask & input;
  *val = *val | (temp << start);
}
void hex_code(int val) {
  char hex[11];
  unsigned int uval = (unsigned int)val, aux;

  hex[0] = '0';
  hex[1] = 'x';
  hex[10] = '\n';

  for (int i = 9; i > 1; i--) {
    aux = uval % 16;
    if (aux >= 10)
      hex[i] = aux - 10 + 'A';
    else
      hex[i] = aux + '0';
    uval = uval / 16;
  }
}

int main(void) {
  char input[30];
  scanf("%[^\n]%*c", input);
  printf("%s\n", input);

  int n1, n2, n3, n4, n5;
  n1 = read_num(input, 0, 5);
  n2 = read_num(input, 6, 11);
  n3 = read_num(input, 12, 17);
  n4 = read_num(input, 18, 23);
  n5 = read_num(input, 24, 29);
  printf("%d %d %d %d %d\n", n1, n2, n3, n4, n5);
  int final = 0;
  pack(n1, 0, 2, &final);
  pack(n2, 3, 10, &final);
  pack(n3, 11, 15, &final);
  pack(n4, 16, 20, &final);
  pack(n5, 21, 31, &final);
  printf("%d\n", final);
  hex_code(final);

  return 0;
}
