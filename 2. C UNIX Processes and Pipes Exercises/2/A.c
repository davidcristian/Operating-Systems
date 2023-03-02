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

    int a, b;
    printf("a=");
    scanf("%d", &a);
    printf("b=");
    scanf("%d", &b);

    if (a < 0) a = -a;   
    if (b < 0) b = -b;   
    int aa = a, bb = b;

    while (aa != bb)
    {
        if (aa > bb)
            aa -= bb;
        else
            bb -= aa;
    }

    int lcm = (a * b) / aa;
    write(fifo, &lcm, sizeof(int));

    close(fifo);
    unlink(fifoName);
    return 0;
}

