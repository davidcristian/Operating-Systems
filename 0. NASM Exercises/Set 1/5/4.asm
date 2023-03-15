bits 32
global start

extern exit
import exit msvcrt.dll

; Exercise 4
; Two byte strings S1 and S2 are given, having the same length. Obtain the string D in the following way: each element found on the even positions of D is the sum of the corresponding elements from S1 and S2, and each element found on the odd positions of D is the difference of the corresponding elements from S1 and S2. Example:
    ; S1: 1, 2, 3, 4
    ; S2: 5, 6, 7, 8
    ; D: 6, -4, 10, -4
    
segment data use32 class=data
    S1 db 1, 2, 3, 4
    len equ $-S1 ; initialize length here before the second string to avoid dividing by 2
    
    S2 db 5, 6, 7, 8
    D resb len

segment code use32 class=code
start:
    mov ecx, len ; loop len times
    jecxz end_program ; jump to end if ecx is 0
    
    mov esi, 0 ; initialize string address index
    loop_through:
        mov al, [S1+esi] ; move the current value from the first string to al
        mov bl, [S2+esi] ; move the current value from the second string to bl
    
        test esi, 1 ; check if esi is even or odd (lowest bit set)
        jnz is_odd ; if esi is odd jump to the is_odd label (ZF=0)
        
        is_even: ; if esi is even continue
        add al, bl ; do the addition as per the exercise
        jmp end_loop ; jump to the end of the loop to avoid the is_odd label
        
        is_odd:
        sub al, bl ; do the substraction as per the exercise
        
        end_loop:
        mov [D+esi], al ; move the computer character into the D string at the esi position
        inc esi ; increment esi to the next index
    loop loop_through
    
    end_program: ; label used in case the strings are of length 0
    ; exit(0)
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program
