#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        perror("Give at least one argument.");
        exit(1);
    }

    int rwA[2];
    if (pipe(rwA) < 0)
    {
        perror("Unable to create pipe.");
        exit(2);
    }
    
    int rwB[2];
    if (pipe(rwB) < 0)
    {
        perror("Unable to create pipe.");
        exit(3);
    }

    for (int i = 1; i < argc; i++)
    {
        int childA = fork();
        if (childA < 0)
        {
            perror("Unable to create child A.");
            exit(4);
        }
        if (childA == 0)
        {
            close(rwB[0]);
            close(rwB[1]);

            close(rwA[0]);
            
            int len = strlen(argv[i]);

            write(rwA[1], &len, sizeof(int));
            close(rwA[1]);
            exit(0);
        }

        int childB = fork();
        if (childB < 0)
        {
            perror("Unable to create child B.");
            exit(5);
        }
        if (childB == 0)
        {
            close(rwA[0]);
            close(rwA[1]);

            close(rwB[0]);
            
            int digit;
            int sum = 0;
            for (int j = 0; j < strlen(argv[i]); j++)
            {
                char c = argv[i][j];
                if (c >= '0' && c <= '9')
                {
                    digit = c - '0';
                    sum += digit;
                }
            }

            write(rwB[1], &sum, sizeof(int));
            close(rwB[1]);
            exit(0);
        }
    }

    for (int i = 1; i < argc; i++)
    {
        wait(0);
        wait(0);
    }

    close(rwA[1]);
    close(rwB[1]);
    
    int num, count = 0, avg = 0;
    while(read(rwA[0], &num, sizeof(int)) > 0)
    {
        avg += num;
        count++;
    }
    close(rwA[0]);

    int sum = 0;
    while(read(rwB[0], &num, sizeof(int)) > 0)
    {
        sum += num;
    }
    close(rwB[0]);

    printf("Average argument length: %d\n", avg / count);
    printf("Sum of digits: %d\n", sum);
    return 0;
}

