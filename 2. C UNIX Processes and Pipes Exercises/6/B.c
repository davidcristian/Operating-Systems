#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

#define VOWELS 5
static char V[] = { "AEIOU" };

int main(int argc, char** argv)
{
    int fifo = open("fifo6", O_RDONLY);

    int* arr = (int *)malloc(VOWELS * sizeof(int));
    read(fifo, arr, VOWELS * sizeof(int));
    
    for (int i = 0; i < VOWELS; i++)
    {
        printf("%c: %d\n", V[i], arr[i]);
    }
    
    close(fifo);
    free(arr);
    return 0;
}

