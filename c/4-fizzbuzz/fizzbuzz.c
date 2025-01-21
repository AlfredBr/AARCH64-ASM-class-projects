#include <stdio.h>
#include <stdlib.h>

char *fn(int x, char *s)
{
	return (x == 0) ? s : "";
}

int main()
{
	const int MAX = 100;
	for (int x = 0; x < MAX; x++)
	{
		char *f = fn(x % 3, "Fizz");
		char *b = fn(x % 5, "Buzz");
		int n = printf("%s%s", f, b);
		if (n == 0)
		{
			printf("%d", x);
		}
		printf("\n");
	}
	return 0;
}