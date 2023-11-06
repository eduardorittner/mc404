
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

void _start() {
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD 0
#define STDOUT_FD 1

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
  write(1, hex, 11);
}

int main(void) {
  char input[30];
  read(STDIN_FD, input, 30);

  int n1, n2, n3, n4, n5;
  n1 = read_num(input, 0, 5);
  n2 = read_num(input, 6, 11);
  n3 = read_num(input, 12, 17);
  n4 = read_num(input, 18, 23);
  n5 = read_num(input, 24, 29);
  int final = 0;
  pack(n1, 0, 2, &final);
  pack(n2, 3, 10, &final);
  pack(n3, 11, 15, &final);
  pack(n4, 16, 20, &final);
  pack(n5, 21, 31, &final);
  hex_code(final);

  return 0;
}
