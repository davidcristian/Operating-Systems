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

    char c;
    while (fscanf(file, "%c", &c) != EOF && --n > 0)
    {
        ;
    }

    write(w, &c, sizeof(char));
}

void P2(int fifo, int r)
{
    char c;
    read(r, &c, sizeof(char));
    
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
        printf("%c is a letter\n", c);
    else if (c >= '0' && c <= '9')
        printf("%c is a digit\n", c);
    else
        printf("%c is a special character\n", c);
    
    write(fifo, &c, sizeof(char));
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

    mkfifo("fifo4", 0600);
    int fifo = open("fifo4", O_WRONLY);

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

