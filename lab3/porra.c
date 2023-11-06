#include <stdio.h>
#include <stdlib.h>

void fodase() {
  char *a = malloc(1 * sizeof(char));
  printf("%p\n", a);
  fodase();
}

int main() {
  fodase();
  return 0;
}
