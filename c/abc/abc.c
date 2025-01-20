#include <stdio.h>

int main() {
	int start = 65;
	int end = start + 26;
	for (int i = start; i < end; i++)
	{
		printf("%c", i);
	}
	printf("\n");
	return 0;
}