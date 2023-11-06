#include <stdlib.h>

int funcao(int valor) {

  if (valor > 20) {
    return 0;
  } else if (valor < 10) {
    return 1;
  } else if (valor < 11) {
    return 2;
  } else if (valor < 12) {
    return 3;
  } else if (valor < 13) {
    return 4;
  } else if (valor < 14) {
    return 5;
  } else if (valor < 15) {
    return 6;
  } else {
    return 7;
  }
}

int main() {

  int a = 30;
  if (funcao(a)) {
    return 1;
  }

  return 0;
}
