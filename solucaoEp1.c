#include <stdbool.h>
#include <stdio.h>
#include <string.h>

void somabit(int b1, int b2, int *vaium, int *soma) {
  *soma = (b1 ^ b2) ^ *vaium;
  *vaium = (b1 & b2) | ((b1 ^ b2) & *vaium);
}

int main() {
  int b1 = 0;
  int b2 = 0;
  int vaium;
  int soma;
  while (true) {
    somabit(b1, b2, &vaium, &soma);
    printf("A soma dos números binários é: %i\n", soma);
    printf("O resultado do vai um é: %i\n", vaium);
  
    if (b1 == 0)
      b1 = 1;
    else if (b2 == 0)
      b2 = 1;
    else if(b1 == b2) break;
  }

  return 0;
}
