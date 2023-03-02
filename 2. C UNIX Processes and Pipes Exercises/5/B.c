#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>

void P1(int fifo, int w)
{
    int sum = 0;
    int num;

    while (read(fifo, &num, sizeof(int)) > 0)
    {
        sum += num;
    }

    write(w, &sum, sizeof(int));
}

void P2(int r)
{
    int sum;
    read(r, &sum, sizeof(int));
    printf("sum=%d\n", sum);
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        perror("Provide only the fifo name as an argument.");
        exit(1);
    }

    char* fifoName = argv[1];
    int fifo = open(fifoName, O_RDONLY);
    
    int rw[2];
    if (pipe(rw) < 0)
    {
        perror("Unable to create pipe.");
        exit(2);
    }

    int childA = fork();
    if (childA < 0)
    {
        perror("Unable to create P1.");
        exit(3);
    }
    if (childA == 0)
    {
        close(rw[0]);
        P1(fifo, rw[1]);
        
        close(rw[1]);
        close(fifo);

        exit(0);
    }

    int childB = fork();
    if (childB < 0)
    {
        perror("Unable to create P2.");
        exit(4);
    }
    if (childB == 0)
    {
        close(rw[1]);
        close(fifo);
        
        P2(rw[0]);
        close(rw[0]);

        exit(0);
    }

    close(rw[0]);
    close(rw[1]);
    close(fifo);

    wait(0);
    wait(0);
    return 0;
}

