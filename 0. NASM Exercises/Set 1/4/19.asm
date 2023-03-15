bits 32
global start

extern exit
import exit msvcrt.dll

; Exercise 19
; Given the word A, compute the doubleword B as follows:
    ; the bits 28-31 of B have the value 1;
    ; the bits 24- 25 and 26-27 of B are the same as the bits 8-9 of A
    ; the bits 20-23 of B are the invert of the bits 0-3 of A ;
    ; the bits 16-19 of B have the value 0
    ; the bits 0-15 of B are the same as the bits 16-31 of B.

segment data use32 class=data
    a dw 0001_1111_1010_0100b
    b dd 0

segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        ; set the 28-31 bits of b equal to 1
        or ebx, 1111_0000_0000_0000_0000_0000_0000_0000b
          ; ebx=1111_0000_0000_0000_0000_0000_0000_0000b
        
        ; set the 24-25 and 26-27 bits of b equal to the 8-9 bits of a
        mov eax, [a]                 ; eax=0000_0000_0000_0000_0001_1111_1010_0100b
        and ax, 0000_0011_0000_0000b ; eax=0000_0000_0000_0000_0000_0011_0000_0000b
        mov cl, 16
        rol eax, cl ; eax=0000_0011_0000_0000_0000_0000_0000_0000b
        or ebx, eax ; ebx=1111_0011_0000_0000_0000_0000_0000_0000b
        mov cl, 2
        rol eax, cl ; eax=0000_1100_0000_0000_0000_0000_0000_0000b
        or ebx, eax ; ebx=1111_1111_0000_0000_0000_0000_0000_0000b
        
        ; set the 20-23 bits of b equal to the inverse of the 0-3 bits of a
        mov eax, 0
        mov eax, [a] ; eax=0000_0000_0000_0000_0001_1111_1010_0100b
        not eax      ; eax=1111_1111_1111_1111_1110_0000_0101_1011b
        and eax, 0000_0000_0000_0000_0000_0000_0000_1111b ; eax=0000_0000_0000_0000_0000_0000_0000_0100b
        mov cl, 20
        rol eax, cl ; eax=0000_0000_0100_0000_0000_0000_0000_0000b
        or ebx, eax ; ebx=1111_1111_0100_0000_0000_0000_0000_0000b
        
        ; set the 16-19 bits of b equal to 0
        and ebx, 1111_1111_1111_0000_1111_1111_1111_1111b
           ; ebx=1111_1111_0100_0000_0000_0000_0000_0000b
        
        ; set the 0-15 bits of b equal to the 16-31 bits of b
        mov edx, ebx
        and edx, 1111_1111_1111_1111_0000_0000_0000_0000b
        mov cl, 16
        ror edx, cl ; edx=0000_0000_0000_0000_1111_1111_1111_1111b
        or ebx, edx ; ebx=1111_1111_0100_0000_1111_1111_1111_1111b
        
        ; store the final result in b
        mov [b], ebx
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
