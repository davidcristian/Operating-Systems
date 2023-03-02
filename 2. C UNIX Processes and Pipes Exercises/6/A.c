#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <string.h>

#define VOWELS 5

void P1(int w)
{
    char* fileName = (char *)malloc(256 * sizeof(char));
    
    printf("Input file name: ");
    scanf("%255s", fileName);

    int len = strlen(fileName);

    write(w, &len, sizeof(int));
    write(w, fileName, len * sizeof(char));

    free(fileName);
}

void P2(int fifo, int r)
{
    int len;
    read(r, &len, sizeof(int));
    
    char* fileName = (char *)malloc((len + 1) * sizeof(char));
    read(r, fileName, len * sizeof(char));
    fileName[len] = '\0';
    
    FILE* file = fopen(fileName, "r");
    if (file == NULL)
    {
        perror("Unable to open file.");
        exit(4);
    }

    int* arr = (int *)malloc(VOWELS * sizeof(int));
    for (int i = 0; i < VOWELS; i++)
    {
        arr[i] = 0;
    }
       
    char c;    
    while (fscanf(file, "%c", &c) != EOF)
    {
        if (c == 'A')
            arr[0] += 1;
        else if (c == 'E')
            arr[1] += 1;
        else if (c == 'I')
            arr[2] += 1;
        else if (c == 'O')
            arr[3] += 1;
        else if (c == 'U')
            arr[4] += 1;
    }

    write(fifo, arr, VOWELS * sizeof(int));

    fclose(file);
    free(fileName);
    free(arr);
}

int main(int argc, char **argv)
{
    mkfifo("fifo6", 0600);
    int fifo = open("fifo6", O_WRONLY);

    int rw[2];
    if (pipe(rw) < 0)
    {
        perror("Unable to create pipe.");
        exit(1);
    }

    int childA = fork();
    if (childA < 0)
    {
        perror("Unable to create P1.");
        exit(2);
    }
    if (childA == 0)
    {
        close(rw[0]);
        close(fifo);

        P1(rw[1]);

        close(rw[1]);
        exit(0);
    }
    
    int childB = fork();
    if (childB < 0)
    {
        perror("Unable to create P2.");
        exit(3);
    }
    if (childB == 0)
    {
        close(rw[1]);

        P2(fifo, rw[0]);

        close(rw[0]);
        close(fifo);
        exit(0);
    }

    close(rw[0]);
    close(rw[1]);

    close(fifo);
    unlink("fifo6");

    wait(0);
    wait(0);
    return 0;
}
    
