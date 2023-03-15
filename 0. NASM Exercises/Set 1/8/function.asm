bits 32

global start

extern exit, fopen, fread, fclose, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

;  A text file is given. Read the content of the file, count the number of odd digits and display the result on the screen. The name of text file is defined in the data segment.

segment data use32 class=data
    file_name db "number.txt", 0    ; filename to be read
    access_mode db "r", 0           ; file access mode:
    file_descriptor dd -1           ; variable to hold the file descriptor
    
    len equ 9                       ; maximum number of characters to read
    text times len db 0             ; string to hold the text which is read from file
    
    format db "Number of odd digits: %d", 0 ; the format of the string for printf

; our code starts here
segment code use32 class=code
    start:
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4 * 2  ; clean-up the stack

        mov [file_descriptor], eax  ; store the file descriptor returned by fopen

        ; check if fopen() has successfully created the file (EAX != 0)
        cmp eax, 0
        je final

        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the number of chars we've read 
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text        
        call [fread]
        add esp, 4 * 4  ; clean-up the stack
        
        mov ebx, eax    ; save the number of read characters into ebx

        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4 * 1  ; clean-up the stack
        
        mov ecx, ebx    ; loop x times where x is the number of read characters
        jecxz final     ; end the program if we read 0 characters
        
        xor edx, edx    ; initialize the odd digit counter with 0
        mov esi, text       ; initialize the string address
        loop_string:
            lodsb
            test al, 1      ; test the first bit
            
            jz next_element ; jump if zero flag (digit is even) because we only want to count odd digits
            inc edx         ; incremenet the counter if the digit is odd
            
            next_element:
        loop loop_string
        
        ; call printf() to display the result
        ; int printf(const char * format, variable_1, constant_2, ...);
        push dword edx
        push dword format
        call [printf]
        add esp, 4 * 2  ; clean-up the stack
        
        final:  ; program end label
        ; exit(0)
        push dword 0
        call [exit]
