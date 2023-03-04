#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

pthread_mutex_t m;
int a = 0;
int b = 0;

typedef struct {
    int id;
    int x;
    int y;
} arg_t;

void *f(void *param)
{
    arg_t arg = *(arg_t *)param;
    free(param);
    printf("Thread %d - x: %d, y: %d\n", arg.id, arg.x, arg.y);

    int i;
    for (i = 0; i < arg.y; i++)
    {
        pthread_mutex_lock(&m);

        int newA = a + b + arg.x;
        printf("Thread %d (%d/%d) adding (b=%d+x=%d) to a (before: %d, after: %d) and replacing b with %d\n", arg.id, i + 1, arg.y, b, arg.x, a, newA, arg.x);

        a = newA;
        b = arg.x;

        pthread_mutex_unlock(&m);
    }

    return NULL;
}

int main(int argc, char **argv)
{
    if (argc < 3 || argc % 2 == 0)
    {
        perror("Provide pairs of integers!");
        exit(1);
    }

    int i;
    int n = argc - 1;
    
    pthread_mutex_init(&m, NULL);
    pthread_t *t = malloc((n / 2) * sizeof(pthread_t));

    for (i = 0; i < n; i += 2)
    {
        arg_t *a = malloc(sizeof(arg_t));
        a->id = i / 2;
        a->x = atoi(argv[i + 1]);
        a->y = atoi(argv[i + 2]);

        pthread_create(&t[i / 2], NULL, f, (void *)a);
    }

    for (i = 0; i < n; i += 2)
    {
        pthread_join(t[i / 2], NULL);
    }

    pthread_mutex_destroy(&m);
    free(t);

    return 0;
}

