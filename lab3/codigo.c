
int read(int __fd, const void *__buf, int __n) {
  int ret_val;
  __asm__ __volatile__("mv a0, %1           # file descriptor\n"
                       "mv a1, %2           # buffer \n"
                       "mv a2, %3           # size \n"
                       "li a7, 63           # syscall write code (63) \n"
                       "ecall               # invoke syscall \n"
                       "mv %0, a0           # move return value to ret_val\n"
                       : "=r"(ret_val)                   // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
  return ret_val;
}

void write(int __fd, const void *__buf, int __n) {
  __asm__ __volatile__("mv a0, %0           # file descriptor\n"
                       "mv a1, %1           # buffer \n"
                       "mv a2, %2           # size \n"
                       "li a7, 64           # syscall write (64) \n"
                       "ecall"
                       :                                 // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
}

void exit(int code) {
  __asm__ __volatile__("mv a0, %0           # return code\n"
                       "li a7, 93           # syscall exit (64) \n"
                       "ecall"
                       :           // Output list
                       : "r"(code) // Input list
                       : "a0", "a7");
}

int main();

int fodase;

void _start() {
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD 0
#define STDOUT_FD 1
#define MAX 4294967296

int num_size(char *number) {
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

int decimal(char *number) {
  int size = num_size(number);
  int i = 0;
  int current_exponent = 1;
  int result = 0;
  for (; size - i > 0; i++) {
    result += (number[size - i] - 48) * current_exponent;
    current_exponent *= 10;
  }

  if (number[0] == '-') {
    return -result;
  }

  return result + current_exponent * (number[0] - 48);
}

int hexa(char *string) {
  int size = num_size(string);
  int res = 0;
  int temp;
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

void print_decimal_u(unsigned num) {
  int i = 0;
  char result[20];
  int remainder;
  int start = 0;
  while (num != 0) {
    remainder = num % 10;
    if (remainder > 9) {
      result[i] = remainder - 10 + 'a';
    } else {
      result[i] = remainder + '0';
    }
    i++;

    num = num / 10;
  }

  reverse(result, start, i);
  result[i] = '\n';
  write(STDOUT_FD, result, i + 1);
  // printf("%s\n", result);
}

void print_decimal(int num) {
  if (num == -(MAX / 2)) {
    write(STDOUT_FD, "-2147483648\n", 12);
    return;
  }

  int i = 0;
  char result[20];
  int negative = 0;
  int remainder;
  int start = 0;
  if (num < 0) {
    negative = 1;
    num = -num;
  }

  while (num != 0) {
    remainder = (num % 10) + 48;
    result[i] = remainder;
    i++;

    num = num / 10;
  }

  if (negative) {
    result[i] = '-';
    i++;
  }

  reverse(result, start, i);
  result[i] = '\n';
  write(STDOUT_FD, result, i + 1);
  // printf("%s\n", result);
}

void print_binary(int num);

unsigned change_endian(int num) {
  unsigned res;
  int mask = 0b11111111;
  unsigned byte_1 = num & mask;
  unsigned byte_2 = num & (mask << 8);
  unsigned byte_3 = num & (mask << 16);
  unsigned byte_4 = num & (mask << 24);

  res = byte_4 >> 24;
  res = res | (byte_3 >> 8);
  res = res | (byte_2 << 8);
  res = res | (byte_1 << 24);

  return res;
}

void print_binary(int num) {
  char numero[40];
  numero[0] = '0';
  numero[1] = 'b';
  int mask = 0b1;
  int temp;
  for (int i = 2; i < 34; i++) {
    temp = (mask & num);
    numero[i] = temp + 48;
    num = num >> 1;
  }

  int offset;
  for (offset = 34; numero[offset] != '1'; offset--) {
  }

  reverse(numero, 2, offset + 1);
  numero[offset + 1] = '\n';
  write(STDOUT_FD, numero, offset + 2);

  // printf("%s\n", numero);
}

void print_hexa(int num) {
  char numero[40];
  numero[0] = '0';
  numero[1] = 'x';
  int mask = 0b1111;
  int temp;
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
  numero[offset + 1] = '\n';

  write(STDOUT_FD, numero, offset + 2);

  // printf("%s\n", numero);
}

void print(int num) {
  print_binary(num);
  print_decimal(num);
  print_hexa(num);
  print_decimal_u(change_endian(num));
}

int main() {

  char numero[20];
  int n = read(STDIN_FD, numero, 20);
  int valor;

  if (numero[1] == 'x') {
    valor = hexa(numero);
    print(valor);
  } else {
    valor = decimal(numero);
    print(valor);
  }

  return 0;
}
