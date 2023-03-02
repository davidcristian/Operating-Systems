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

    char fileName[32];
    printf("Input file name: ");
    scanf("%31s", fileName);

    FILE* file = fopen(fileName, "r");
    if (file == NULL)
    {
        perror("Unable to open file.");
        exit(2);
    }
    
    char c;    
    while (fscanf(file, "%c", &c) != EOF)
    {
        if (c >= '0' && c <= '9')
        {
            int digit = c - '0';
            write(fifo, &digit, sizeof(int));
        }
    }
    
    fclose(file);
    close(fifo);
    unlink(fifoName);
    return 0;
}

