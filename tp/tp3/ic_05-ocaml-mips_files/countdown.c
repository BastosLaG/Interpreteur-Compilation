#include <stdio.h>

void countdown_rec (int n)
{
  if (n != 0) {
    printf("%d\n", n);
    countdown(n - 1);
  }
  else {
    printf("BOUM!\n");
  }
}

void countdown_loop (int n)
{
  while (n != 0) {
    printf("%d\n", n);
    n = n - 1;
  }
  printf("BOUM!\n");
}

int main ()
{
  int n;
  printf("Count from? ");
  scanf("%d", &n);
  countdown_rec(n);
  return 0;
}
