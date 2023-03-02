#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>

void P1(FILE* file, int w)
{
    int n;
    printf("n=");
    scanf("%d", &n);

    int num;
    while (fscanf(file, "%d", &num) != EOF && n-- > 0)
    {
        write(w, &num, sizeof(int));
    }
}

void P2(int fifo, int r)
{
    int sum = 0;

    int num;
    while(read(r, &num, sizeof(int)) > 0)
    {
        if (num % 2 != 0)
            sum += num;
    }
    
    write(fifo, &sum, sizeof(int));
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        perror("Provide only the file name as an argument.");
        exit(1);
    }

    char* fileName = argv[1];
    FILE* file = fopen(fileName, "r");
    if (file == NULL)
    {
        perror("Unable to open file.");
        exit(2);
    }

    mkfifo("fifo3", 0600);
    int fifo = open("fifo3", O_WRONLY);

    int rw[2];
    if (pipe(rw) < 0)
    {
        perror("Unable to create pipe.");
        exit(3);
    }

    int childA = fork();
    if (childA < 0)
    {
        perror("Unable to create P1.");
        exit(4);
    }
    if (childA == 0)
    {
        close(rw[0]);
        close(fifo);

        P1(file, rw[1]);

        fclose(file);
        close(rw[1]);
        exit(0);
    }
    
    int childB = fork();
    if (childB < 0)
    {
        perror("Unable to create P2.");
        exit(5);
    }
    if (childB == 0)
    {
        close(rw[1]);
        fclose(file);

        P2(fifo, rw[0]);

        close(rw[0]);
        close(fifo);
        exit(0);
    }
    
    fclose(file);

    close(rw[0]);
    close(rw[1]);

    close(fifo);
    unlink("fifo3");

    wait(0);
    wait(0);
    return 0;
}

