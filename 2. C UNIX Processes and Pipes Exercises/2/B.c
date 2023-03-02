#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>

void P1(int fifo, int w)
{
    int lcm;
    read(fifo, &lcm, sizeof(int));
    for (int i = 1; i <= lcm; i++)
    {
        if (lcm % i == 0)
            write(w, &i, sizeof(int));
    }

}

void P2(int r)
{
    int num;
    while (read(r, &num, sizeof(int)) > 0)
    {
        printf("%d ", num);
    }
    printf("\n");
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

