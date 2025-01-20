#include <stdio.h>
#include <stdlib.h>

char * f(int x, char *s)
{
    return (x == 0) ? s : "";
}

int main()
{
    for (int x = 0; x < 32; x++)
    {
        printf("%d %s%s\n", x, f(x % 3, "Fizz"), f(x % 5, "Buzz"));
    }
    exit(0);
}