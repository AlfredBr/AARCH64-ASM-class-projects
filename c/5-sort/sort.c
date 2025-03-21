#include <stdio.h>
#include <stdlib.h>

#define N 10

void swap(int *a, int *b)
{
	int t = *a;
	*a = *b;
	*b = t;
}

void println(int *a)
{
	for (int i = 0; i < N; i++)
	{
		printf("%d ", a[i]);
	}
	printf("\n");
}

int main()
{
	// 1. The outer loop iterates over each element.
	// 2. The inner loop compares the current element with each element to its right.
	// 3. When a smaller element is found, it is immediately swapped with the current element.
	// 4. This progressively moves the smallest element in the unsorted portion to the beginning.

	int a[N] = {5, 4, 3, 2, 1, 9, 8, 7, 6, 0};

	for (int i = 0; i < N; i++)
	{
		for (int j = i + 1; j < N; j++)
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