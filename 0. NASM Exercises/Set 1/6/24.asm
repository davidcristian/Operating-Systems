bits 32
global start

extern exit
import exit msvcrt.dll

; 24. Being given a string of doublewords, build another string of doublewords which will include only the doublewords from the given string which have an even number of bits with the value 1.

segment data use32 class=data
    s DD 5, 6, 7, 8, 9, 10, 11
    len equ ($-s)/4
    d resd len
    ; 5, 6, 9, 10

segment code use32 class=code
start:
    mov ecx, len ; load the length of s into ecx
    jecxz end_program ; jump to the end if ecx is 0

    mov esi, s ; load the offset of the s string into esi
    mov edi, d ; load the offset of the d string into edi
    
    CLD ; clear the direction flag
    loop_string:
        LODSD ; load the value into eax
        mov edx, 0 ; clear edx to count the number of set bits
        
        shr eax, 1 ; move rightmost bit to carry flag
        count_ones:
        adc dl, 0 ; add with carry
        shr eax, 1 ; move rightmost bit to carry flag
        jnz count_ones ; loop while ZF=1
        adc dl, 0 ; count last bit
        
        test dl, 1 ; check if the number of set bits is even or odd (lowest bit set)
        jnz is_odd ; if esi is odd jump to the is_odd label (ZF=0)
        
        mov ebx, esi ; move the address of the current value from s into ebx
        sub ebx, s ; substract the starting address of the s string from ebx
        
        mov eax, [s+ebx] ; move ebx into eax to prepare for the next instruction
        STOSD ; add the value into d if it has an even number of set bits
        
        is_odd:
    loop loop_string
    
    end_program: ; program end label
    ; exit(0)
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program
