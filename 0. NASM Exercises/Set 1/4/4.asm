bits 32
global start

extern exit
import exit msvcrt.dll

; Exercise 4
; Given the byte A, obtain the integer number n represented on the bits 2-4 of A. Then obtain the byte B by rotating A n positions to the right. Compute the doubleword C as follows:
    ; the bits 8-15 of C have the value 0
    ; the bits 16-23 of C are the same as the bits of B
    ; the bits 24-31 of C are the same as the bits of A
    ; the bits 0-7 of C have the value 1
    
segment data use32 class=data
    a db 0110_1001b
    b db 0
    c dd 0
    n db 0

segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0

        ; obtaining n
        mov al, [a]
        and al, 0001_1100b
        mov cl, 2
        ror al, cl
        or bl, al
        mov [n], bl

        ; obtaining b
        mov al, [a]
        mov cl, [n]
        ror al, cl
        mov [b], al

        ; empty registers
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0

        ; set the 8-15 bits of c to 0
        and bx, 0000_0000_1111_1111b

        ; set the 16-23 bits of c equal to b
        mov al, [b]
        mov cl, 8
        rol eax, cl ; 0000_0000_0000_0000_0000_0000_0000_1110
        or ebx, eax

        ; set the 24-31 bits of c equal to a
        mov eax, 0
        mov al, [a]
        mov cl, 16
        rol eax, cl
        or ebx, eax

        ; set the 0-7 bits of bl equal 1
        or bl, 1111_1111b

        ; store the final result in c
        mov [c], ebx
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
