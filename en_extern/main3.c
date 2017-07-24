#include <stdio.h>

extern int version();

int main() {
	printf("version=%d\n", version());
	return 0;
}
