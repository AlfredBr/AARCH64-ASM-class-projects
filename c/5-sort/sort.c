#include <stdio.h>
#include <stdlib.h>

#define N 10

void swap(int *a, int *b)
{
	int t = *a;
	*a = *b;
	*b = t;
}

void print(int *a)
{
	for (int i = 0; i < N; i++)
	{
		printf("%d ", a[i]);
	}
	printf("\n");
}

int main()
{
	int a[N] = {5, 4, 3, 2, 1, 9, 8, 7, 6, 0};
	int i, j;

	for (i = 0; i < N; i++)
	{
		for (j = i + 1; j < N; j++)
		{
			print(a);
			if (a[i] > a[j])
			{
				swap(&a[i], &a[j]);
			}
		}
	}
	print(a);

	return EXIT_SUCCESS;
}