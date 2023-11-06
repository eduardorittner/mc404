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

int square(int num) {
  int temp = num / 2;

  for (int i = 0; i < 10; i++) {
    temp = (temp + num / temp) / 2;
  }
  return temp;
}

int decimal(char *number) {
  int size = 4;
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

int main() {
  char _n1[4];
  char _n2[4];
  char _n3[4];
  char _n4[4];
  char fodase[10];
  read(0, _n1, 4);
  read(0, fodase, 1);
  read(0, _n2, 4);
  read(0, fodase, 1);
  read(0, _n3, 4);
  read(0, fodase, 1);
  read(0, _n4, 4);

  int n1 = decimal(_n1);
  int n2 = decimal(_n2);
  int n3 = decimal(_n3);
  int n4 = decimal(_n4);

  return 0;
}
