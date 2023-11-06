int read(int __fd, const void *__buf, int __n) {
  int ret_val;
  __asm__ __volatile__("mv a0, %1           # file descriptor\n"
                       "mv a1, %2           # buffer \n"
                       "mv a2, %3           # size \n"
                       "li a7, 63           # syscall read code (63) \n"
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

void iota(int numero, char resultado[]) {
  resultado[0] = numero + 48;
  resultado[1] = '\n';
}

int atoi(char numero) { return numero - 48; }

void operacao(char s1, char op, char s2, char resultado[]) {
  int i1 = atoi(s1);
  int i2 = atoi(s2);

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

  iota(i1, resultado);
}

void exit(int code) {
  __asm__ __volatile__("mv a0, %0           # return code\n"
                       "li a7, 93           # syscall exit (64) \n"
                       "ecall"
                       :           // Output list
                       : "r"(code) // Input list
                       : "a0", "a7");
}

#define STDIN_FD 0
#define STDOUT_FD 1

int main() {
  char in[6];
  char resultado[3];
  int tam;

  read(STDIN_FD, in, 5);
  operacao(in[0], in[2], in[4], resultado);
  write(STDOUT_FD, resultado, 2);
  return 0;
}

void _start() {
  int ret_code = main();
  exit(ret_code);
}
