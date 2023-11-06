int iota(int numero, char resultado[]) {
  if (numero > 9) {
    resultado[0] = (numero / 10) + 48;
    numero -= (numero / 10) * 10;
    resultado[1] = (numero) + 48;
    return 2;
  } else if (numero > 0) {
    resultado[0] = numero + 48;
    resultado[1] = '\n';
    resultado[2] = '\0';
    return 1;
  } else {
    resultado[0] = '-';
    resultado[1] = 48 - numero;
    resultado[2] = '\n';
    return 2;
  }
}

int atoi(char numero) {
  switch (numero) {
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
    return 6;
  case '7':
    return 7;
  case '8':
    return 8;
  case '9':
    return 9;
  }
}

int operacao(char s1, char op, char s2, char resultado[]) {
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

  return iota(i1, resultado);
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
  char resultado[4] = "0";
  resultado[1] = '0';
  resultado[2] = 48;
  resultado[3] = '\n';

  read(STDIN_FD, in, 5);
  int tam = operacao(in[0], in[2], in[4], resultado);
  write(STDOUT_FD, resultado, tam + 1);
  return 0;
}
