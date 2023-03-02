# Set 1

Write 2 programs named A and B in C.
Both programs should successfully compile with `gcc -Wall -g` and have no warnings.
Both programs must run without memory leaks, context errors or zombie processes.

1) Program A will read a file name from the keyboard, then it will read from the file and send all the digits to program B through a FIFO. Program B will create 2 processes, P1 and P2. P1 will read the digits from the aforementioned FIFO and compute the sum, then send the sum to P2 through a pipe. P2 will display all the divisors of the received sum.
The name of the FIFO will be given as a command line argument in both of the programs.

2) Program A will read two integers from the keyboard, then it will compute the LCM and send it to program B through a FIFO. Program B will create 2 processes, P1 and P2. P1 will read the LCM from the aforementioned FIFO and compute its divisors. The divisors will be passed to the P2 process through a pipe. P2 will display the received numbers.
The name of the FIFO will be given as a command line argument in both of the programs.

3) Program A will create 2 processes, P1 and P2. P1 will receive a file name for a file containing only numbers from the command line arguments, then it will read from the standard input (keyboard) a number `n`. P1 will send the first `n` numbers from the file to P2 through a pipe. P2 will send the sum of all the received odd numbers to program B through a FIFO. Program B will display the received number.

4) Program A will create 2 processes, P1 and P2. P1 will receive a file name for a file containing random text from the command line arguments, then it will read from the standard input (keyboard) a number `n`. P1 will send the character found on the Nth position in the file to P2 through a pipe. P2 will display the nature of that character (letter, digit, or special character) and will send it to B through a FIFO. Program B will display the ASCII code of the received character.

5) Program A will read an integer from the standard input (keyboard), then it will compute all the divisors of the read number and send them to program B through a FIFO. Program B will create 2 processes, P1 and P2. P1 will read the divisors from the aforementioned FIFO and it will compute the sum of the received numbers. The sum will be transmitted to process P2 through a pipe. P2 will display the received number.
The name of the FIFO will be given as a command line argument in both of the programs.

6) Program A will create 2 prcesses, P1 and P2. P1 will read from the standard input (keyboard) the path to a file `f` that can have any character any number of times. P1 will send the file path to P2 through a pipe. P2 will send an array of 5 numbers, each representing the frequency of an uppercase vowel (A,E,I,O,U), to program B through a FIFO. Program B will display the frequency of each uppercase vowel.

# Extra

### 1

For each command-line argument create two new processes (A and B).

Process A will establish the length of its corresponding argument and send the value to the parent process (using a separate communication channel).

Process B will compute the sum of the digits found in the corresponding argument and send the value to the parent process (using a separate communication channel).

Once all child processes are done the parent will print the average argument length received from `A` processes, and the sum of all the values received from `B` processes.
