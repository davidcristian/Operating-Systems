#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

int main(int argc, char** argv)
{
    int fifo = open("fifo4", O_RDONLY);

    char c;
    read(fifo, &c, sizeof(char));

    printf("ascii of %c is %d\n", c, c);
    
    close(fifo);
    return 0;
}

