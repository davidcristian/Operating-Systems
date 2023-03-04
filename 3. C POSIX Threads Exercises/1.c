#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int current = 0;
int* arr;

pthread_barrier_t barrier;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void *f(void *arg)
{
    int id = *(int *)arg;
    free(arg);

    printf("Thread %d waiting at barrier.\n", id);
    pthread_barrier_wait(&barrier);
    printf("Thread %d started appending.\n", id);

    int i, last;
    for(i = 0; i < 10; i++)
    {
        pthread_mutex_lock(&lock);
        arr[current++] = id;
        last = current;
        pthread_mutex_unlock(&lock);
        
        // Add a 1 ms delay because the threads
        // are too fast to see a difference
        usleep(1000);
    }

    printf("Thread %d last append: %d\n", id, last);
    return NULL;
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        perror("Invalid number of arguments!");
        exit(1);
    }

    int i, n = atoi(argv[1]);
    arr = (int *)malloc((n * 10) * sizeof(int));

    pthread_t* t = (pthread_t *)malloc(n * sizeof(pthread_t));
    pthread_barrier_init(&barrier, NULL, n);

    for (i = 0; i < n; i++)
    {
        int *id = (int *)malloc(sizeof(int));
        *id = i;
        pthread_create(&t[i], NULL, f, (void *)id);
    }

    for (i = 0; i < n; i++)
    {
        pthread_join(t[i], NULL);
    }
    
    pthread_barrier_destroy(&barrier);
    pthread_mutex_destroy(&lock);

    free(t);
    free(arr);

    return 0;
}

