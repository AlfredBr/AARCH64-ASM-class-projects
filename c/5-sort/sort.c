#include <stdio.h>
#include <stdlib.h>

#define N 10

void swap(int *a, int *b)
{
	auto t = *a;
	*a = *b;
	*b = t;
}

void println(int *a)
{
	for (auto i = 0; i < N; i++)
	{
		printf("%d ", a[i]);
	}
	printf("\n");
}

int main()
{
	auto a[N] = {5, 4, 3, 2, 1, 9, 8, 7, 6, 0};

	for (auto i = 0; i < N; i++)
	{
		for (auto j = i + 1; j < N; j++)
		{
			println(a);
			if (a[i] > a[j])
			{
				swap(&a[i], &a[j]);
			}
		}
	}
	println(a);

	return EXIT_SUCCESS;
}