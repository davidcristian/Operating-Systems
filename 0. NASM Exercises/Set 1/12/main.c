#include <stdio.h>

void decimal();
void hex();
void binary();

// 4. A string of numbers is given. Show the values in base 16 and base 2.

int main()
{
    decimal();
    hex();
    binary();

    printf("\n\nThis line is printed from the C file!");
    printf("\nPress ENTER to continue.");
    getchar();

    return 0;
}
