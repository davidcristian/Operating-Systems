#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

int main(int argc, char** argv)
{
    int fifo = open("fifo3", O_RDONLY);

    int sum;
    read(fifo, &sum, sizeof(int));

    printf("odd sum=%d\n", sum);
    
    close(fifo);
    return 0;
}

