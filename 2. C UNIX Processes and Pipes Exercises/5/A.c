#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        perror("Provide only the fifo name as an argument.");
        exit(1);
    }

    char* fifoName = argv[1];
    mkfifo(fifoName, 0600);
    int fifo = open(fifoName, O_WRONLY);

    int num;
    printf("n=");
    scanf("%d", &num);

    if (num < 0) num = -num;   

    for (int i = 1; i <= num; i++)
    {
        if (num % i == 0)
            write(fifo, &i, sizeof(int));
    }

    close(fifo);
    unlink(fifoName);
    return 0;
}

