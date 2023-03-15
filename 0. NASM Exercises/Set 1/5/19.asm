bits 32
global start

extern exit
import exit msvcrt.dll

; Exercise 19
; Two byte strings A and B are given. Obtain the string R that contains only the even negative elements of the two strings. Example:
    ; A: 2, 1, 3, -3, -4, 2, -6
    ; B: 4, 5, -5, 7, -6, -2, 1
    ; R: -4, -6, -6, -2
    
segment data use32 class=data
    A db 2, 1, 3, -3, -4, 2, -6
    lenA equ $-A
    
    B db 4, 5, -5, 7, -6, -2, 1
    lenB equ $-B
    
    R resb lenA+lenB

segment code use32 class=code
start:
    mov edi, 0 ; initialize string address index for R
    
    mov ecx, lenA ; loop lenA times
    jecxz second_string ; jump to the second string if ecx is 0
    
    mov esi, 0 ; initialize string address index for A
    first_loop:
        mov al, [A+esi] ; move the current value from the first string to al
        test al, 1 ; check if al is even or odd (lowest bit set)
        jnz end_first_loop ; if al is odd jump to the end_first_loop label (ZF=0)
        
        test al, al ; check if al is positive or negative
        jns end_first_loop ; if al is positive jump to the end_first_loop label (SF=0)

        mov [R+edi], al ; if all the checks passed save the current value in R
        inc edi ; increment edi to the next index
        
        end_first_loop:
        inc esi ; increment esi to the next index
    loop first_loop
    
    second_string: ; label used in case the first string has a length of 0
    mov ecx, lenB ; loop lenB times
    jecxz end_program ; jump to end if ecx is 0
    
    mov esi, 0 ; initialize string address index for B
    second_loop:
        mov al, [B+esi] ; move the current value from the second string to al
        test al, 1 ; check if al is even or odd (lowest bit set)
        jnz end_second_loop ; if al is odd jump to the end_second_loop label (ZF=0)
        
        test al, al ; check if al is positive or negative
        jns end_second_loop ; if al is positive jump to the end_first_loop label (SF=0)

        mov [R+edi], al ; if all the checks passed save the current value in R
        inc edi ; increment edi to the next index
        
        end_second_loop:
        inc esi ; increment esi to the next index
    loop second_loop
    
    end_program: ; label used in case the second string has a length of 0
    ; exit(0)
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program
