#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		fprintf(stderr, "Usage: %s <year>\n", argv[0]);
		return EXIT_FAILURE;
	}

	int year = atoi(argv[1]);

	if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
	{
		printf("✅ %d is a leap year\n", year);
	}
	else
	{
		printf("🛑 %d is NOT a leap year\n", year);
	}

	return EXIT_SUCCESS;
}