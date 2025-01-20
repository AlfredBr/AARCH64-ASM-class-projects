#include <stdio.h>
#include <stdlib.h>

char * f(int x, char *s)
{
    return (x == 0) ? s : "";
}

int main()
{
	const int MAX = 32;
    for (int x = 0; x < MAX; x++)
    {
        printf("%d %s%s\n", x, f(x % 3, "Fizz"), f(x % 5, "Buzz"));
    }
    return 0;
}