#include <stdio.h>
#include <stdlib.h>

int string_to_int(char tamanho) {
  switch (tamanho) {
  case '0':
    return 0;
  case '1':
    return 1;
  case '2':
    return 2;
  case '3':
    return 3;
  case '4':
    return 4;
  case '5':
    return 5;
  case '6':
    return 6;
  case '7':
    return 7;
  case '8':
    return 8;
  case '9':
    return 9;
  }
  return 0;
}
int int_to_string(int tamanho, char resultado[]) {
  if (tamanho > 9) {
    resultado[0] = (tamanho / 10) + 48;
    tamanho -= (tamanho / 10) * 10;
    resultado[1] = tamanho + 48;
    resultado[2] = '\n';
    return 2;
  } else if (tamanho > 0) {
    resultado[0] = tamanho + 48;
    resultado[1] = '\n';
    return 1;
  } else {
    resultado[0] = '-';
    resultado[1] = 48 - tamanho;
    resultado[2] = '\n';
    return 2;
  }
}

int operacao(char s1, char op, char s2, char resultado[]) {
  int i1 = string_to_int(s1);
  int i2 = string_to_int(s2);

  switch (op) {
  case '+':
    i1 += i2;
    break;
  case '-':
    i1 -= i2;
    break;
  case '*':
    i1 *= i2;
    break;
  }

  return int_to_string(i1, resultado);
}

int main() {
  char string[7];
  char resultado[3];
  int tamanho;
  char s1, s2, s3;

  scanf("%c %c %c", &s1, &s2, &s3);
  string[0] = s1;
  string[1] = ' ';
  string[2] = s2;
  string[3] = ' ';
  string[4] = s3;

  tamanho = operacao(string[0], string[2], string[4], resultado);
  printf("resultado: %s", resultado);

  return 0;
}
