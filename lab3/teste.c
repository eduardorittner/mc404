#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 4294967296

static int num_size(char *number) {
  int i;
  for (i = 0; number[i] != '\0' && number[i] != '\n'; i++) {
  }
  return i - 1;
}

void reverse(char str[], int start, int len) {
  int end = len - 1;
  char temp;
  while (start < end) {
    temp = str[start];
    str[start] = str[end];
    str[end] = temp;
    end--;
    start++;
  }
}

int32_t decimal(char *number) {
  int size = num_size(number);
  int i = 0;
  int current_exponent = 1;
  int64_t result = 0;
  for (; size - i > 0; i++) {
    result += (number[size - i] - 48) * current_exponent;
    current_exponent *= 10;
  }

  if (number[0] == '-') {
    return -result;
  }

  return result + current_exponent * (number[0] - 48);
}

int32_t hexa(char *number) {
  int size = num_size(number);
  int i = 0;
  int current_exponent = 1;
  int64_t result = 0;
  for (; size - i > 1; i++) {
    if (number[size - i] > 96) {
      result += (number[size - i] - 87) * current_exponent;
    } else {
      result += (number[size - i] - 48) * current_exponent;
    }
    current_exponent *= 16;
  }

  if (result >= MAX / 2) {
    result -= MAX * 2;
  }

  return result;
}

char *twos_complement(int number);

char *to_binary(int32_t number) {

  char *result = malloc(33 * sizeof(char));
  char temp[33];
  int bit;
  result[0] = '0';
  result[1] = 'b';
  if (number < 0) {
    return twos_complement(number);
  }
  int i = 2;
  for (; number > 0; i++) {
    temp[i] = number % 2;
    number /= 2;
  }
  i--;
  int j = 0;
  for (; j + 2 <= i; j++) {
    result[2 + j] = temp[i - j] + 48;
  }
  result[2 + j] = '\0';
  return result;
}

void shift_left(char *number, int size) {
  number[size + 2] = '\0';
  for (int i = size; i > 1; i--) {
    number[i + 1] = number[i];
  }
  number[2] = '1';
}

char *twos_complement(int number) {
  char *u_binary = to_binary(-number);

  int carry = 1;
  int i = 0;
  int size = num_size(u_binary);

  for (int i = 0; size - i > 1; i++) {
    if (u_binary[size - i] == '0') {
      if (!carry) {
        u_binary[size - i] = '1';
      }
    } else {
      if (!carry) {
        u_binary[size - i] = '0';
      }
      carry = 0;
    }
  }
  if (u_binary[2] == '0') {
    shift_left(u_binary, size);
  }

  return u_binary;
}

char *itod(int numero) {
  char *temp = malloc(100 * sizeof(char));
  int current_exponent = 1;
  for (int i = 0; numero > 1; i++) {
    temp[i] = numero % 10;
    numero -= current_exponent * temp[i];
    current_exponent *= 10;
  }

  return temp;
}

char *itonum(int num, int base) {
  int i = 0;
  char *result = malloc(100 * sizeof(char));
  int negative = 0;
  int remainder;
  int start = 0;

  if (base == 2) {
    result[0] = '0';
    result[1] = 'b';
    start = 2;
    i = 2;
  } else if (base == 16) {
    result[0] = '0';
    result[1] = 'x';
    start = 2;
    i = 2;
  }

  if (num < 0) {
    negative = 1;
    num = -num;
  }

  while (num != 0) {
    remainder = num % base;
    if (remainder > 9) {
      result[i] = remainder - 10 + 'a';
    } else {
      result[i] = remainder + '0';
    }
    i++;

    num = num / base;
  }

  if (negative && base == 10) {
    result[i] = '-';
    i++;
  } else {
  }

  result[i] = '\n';
  reverse(result, start, i);
  return result;
}

int32_t change_endian(int32_t num) {
  int32_t res;
  int32_t mask = 0b11111111;
  int32_t byte_1 = num & mask;
  int32_t byte_2 = num & (mask << 8);
  int32_t byte_3 = num & (mask << 16);
  int32_t byte_4 = num & (mask << 24);

  res = byte_4 >> 24;
  res = res | (byte_3 >> 8);
  res = res | (byte_2 << 8);
  res = res | (byte_1 << 24);
  return res;
}

void print_binary(int32_t num) {
  char numero[40] = "0b";
  int32_t mask = 0b1;
  int32_t temp;
  for (int i = 2; i < 35; i++) {
    temp = (mask & num);
    numero[i] = temp + 48;
    num = num >> 1;
  }

  int offset;
  for (offset = 34; numero[offset] != '1'; offset--) {
  }
  reverse(numero, 2, offset + 1);
  numero[offset + 1] = '\0';

  printf("%s\n", numero);
}

void print_decimal(int64_t num) {
  char *numero;
  numero = itonum(num, 10);
  printf("%s", numero);
}

void print_hexa(int32_t num) {
  char numero[40] = "0x";
  int32_t mask = 0b1111;
  int32_t temp;
  for (int i = 2; i < 10; i++) {
    temp = (mask & num);
    if (temp > 9) {
      numero[i] = temp + 87;
    } else {
      numero[i] = temp + 48;
    }
    num = num >> 4;
  }

  int offset;
  for (offset = 9; numero[offset] == '0'; offset--) {
  }

  reverse(numero, 2, offset + 1);
  numero[offset + 1] = '\0';

  printf("%s\n", numero);
}

void print(int64_t num) {
  print_binary(num);
  print_decimal(num);
  print_hexa(num);
  printf("%d\n", change_endian(num));
}

int32_t ret_number(char *string) {
  int size = num_size(string);
  int32_t res = 0;
  int32_t temp;
  for (int i = size; i > 1; i--) {
    if (string[i] > 96) {
      temp = string[i] - 87;
    } else {
      temp = string[i] - 48;
    }
    temp = temp << ((size - i) * 4);
    res = res | temp;
  }
  return res;
}

int main() {
  char numero[20] = "x545648\n";
  int valor;

  int puta;
  puta = 2;
  if (puta) {
    printf("fodase");
    puta--;
  }

  if (numero[1] == 'x') {
    valor = hexa(numero);
    print(valor);
  } else {
    valor = decimal(numero);
    print(valor);
  }

  return 0;
}
