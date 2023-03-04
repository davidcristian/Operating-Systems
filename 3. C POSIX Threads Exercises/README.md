# C POSIX Threads Exercises

The threads must be allocated dynamically. Display messages so the execution of the threads can be followed.

The access to the critical resources must be synchronized efficiently (the wait time of each thread must be minimal).

The source file must successfully compile with `gcc -Wall -g -pthread` and have no warnings.

# Set 1

1) Write a C program that receives an integer `n` as a command line argument. The program will create `n` threads. Each thread will receive its thread number as an argument. All threads will have access to a global dynamically allocated array `arr`. The threads will append their thread number to the array 10 times and display the index of the last appended element once finished. All threads must be synchronized to start at the same time.

2) Write a C program that receives pairs of integer numbers, `x` and `y`, as command line arguments. The program will create a thread for every received pair. Each thread will receive one of the pairs as arguments. All threads will have access to 2 global variables, `a` and `b`. The threads will add to `a` the value stored in `b`, then add the value stored in `x`. The value of `b` will then be overwritten with the value of `x`. Each thread will perform these operations `y` times.
