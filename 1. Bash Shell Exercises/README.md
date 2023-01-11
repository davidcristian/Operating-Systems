# Set 1

1) Display a report showing the full names of all the users currently connected and the number of processes belonging to each of them.

2) Find recursively in a directory all the C source files files having more than 500 lines. Stop after you find two such files.

3) Find recursively in a directory all the files with the extension ".log" and sort their lines (replace the original file with the sorted content).

4) Find recursively in a given directory all the symbolic links, and report those that point to files/directories that no longer exist. Use operator "-L" to test if a path is a symbolic link, and operator "-e" to test if it exists (will return false if the target to which the link points does not exist).

5) Write a script that receives dangerous program names as command line arguments. The script will monitor all the processes in the system, and whenever a program known to be dangerous is run, the script will kill it and display a message.

6) Find recursively in a directory all the files that have write permissions for everyone. Display their names and the permissions before and after removing the write permission for everybody. You will need to use chmod's symbolic permissions mode instead of the octal mode. See the chmod manual page for details.

7) Consider a file containing a username on each line. Generate a comma-separated string with the email addresses of the users that exist. The email address will be obtained by appending "@gmail.com" at the end of each username. Make sure the generated string does not end in a comma.

8) Display all the mounted file systems that are either smaller than than 1GB or have less than 20% free space.

9) Write a script that finds, in a given directory hierarchy, all the duplicate files and displays their paths. Use checksums to detect whether two files are identical.

10) Display the session count and full names of all the users who logged into the system this month, sorting the output by the session count in descending order. Use the "-s" and/or "-t" options of the command last to get this month's sessions, and the command date to generate the required timestamp in the expected format.

# Set 2

1) Write a shell script that recursively counts all the C source files in the directories received as arguments.

2) Write a shell script that receives as command line arguments a word (w) followed by 2 numbers (m and n) followed by any number of files. Display the files that contain the word w at least m times on the nth line.

3) Write a shell script that receives as command line arguments a word (w) followed by any number of files. The script will display the number of times the word w appears in each file given as an argument.

4) Write a shell script that receives a number (n) followed by any number of C source files as commnad line arguments. Display a report that shows the libraries used in each file and the top n used libraries.

5) Write a shell script that receives strings as command line arguments. The first 2 arguments will represent 2 file names (f1 and f2). The script will write into f1 all the arguments that are not valid user names in the current system, and write into f2 the full names and the size of the home directory of the valid users, sorted by size in descending order.

6) Write a shell script that receives a file name followed by any number of strings as command line argumets. The file will contain directory names. The script will take all the strings that are valid user names in the current system and create a report that shows all the directories found both in the file given as the first argument and in the home directory of each user received as an argument. If you don't have permission to access a user's home directory, display a message.

7) Write a shell script that receives a number (n), a word (w) followed by any number of files as command line arguments. The script will display the nth line containing the word w from each file.

8) Write a shell script that receives a number (n) followed by any number of files as command line arguments. The script will display all the words with the frequency greater than n from each file.

9) Write a shell script that receives file names as command line arguments. Display the frequency of the even numbers in each file.

# Extra

1) Find recursively in a directory all the files that have their permissions set to 755. Display a prompt and ask the user if they would like to set the permissions of the file to 744. Do this for every file.

2) Write a shell script that displays the number of members of each group given as a command line argument, or -1 if the group does not exist. Sort the output descendingly by the number of members in each group. The /etc/group file contains the information about group membership.
