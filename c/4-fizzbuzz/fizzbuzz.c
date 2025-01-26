#include <stdio.h>
#include <stdlib.h>

char *fn(int x, char *s)
{
	return (x == 0) ? s : "";
}

int implementation1()
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

int implementation2()
{
	const int MAX = 100;
	for (int x = 0; x < MAX; x++)
	{
		int b = 0;
		int n = x / 3;
		int m = n * 3;
		if ((x - m) == 0)
		{
			printf("Fizz");
			b++;
		}
		n = x / 5;
		m = n * 5;
		if ((x - m) == 0)
		{
			printf("Buzz");
			b++;
		}
		if (b == 0)
		{
			printf("%d", x);
		}
		printf("\n");
	}
	return 0;
}

int implementation3()
{
	const int MAX = 100;
	for (int x = 0; x < MAX; x++)
	{
		if (!printf("%s%s", fn(x % 3, "Fizz"), fn(x % 5, "Buzz")))
		{
			printf("%d", x);
		}
		printf("\n");
	}
	return 0;
}

int main()
{
	return implementation3();
}
