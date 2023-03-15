bits 32
extern _printf
global _binary

segment data public data use32
    numbers dd 10, 11, 12, 13, 14, 15, 16, 17, 18
    len equ ($-numbers)/4
    
    newline dd 10
    space dd 32

    binarylabel dd "base 2: ", 0
    binaryformat dd '%d'

; our code starts here
segment code public code use32
    _binary:
        ; call printf() to display the result
        ; int printf(const char * format, variable_1, constant_2, ...);
        push dword binarylabel
        call _printf
        add esp, 4 ; clean-up the stack
        
        mov ecx, len
        mov esi, numbers
        third_loop:
            lodsd
            
            xor edx, edx ; count
            shr eax, 1 ; move rightmost bit to carry flag
            
            count_bits:
                adc dl, 0 ; add with carry
                
                push word ax
                push word cx
                pop ebx
                
                ; call printf() to display the result
                ; int printf(const char * format, variable_1, constant_2, ...);
                push dword edx
                push dword binaryformat
                call _printf
                add esp, 4 * 2  ; clean-up the stack
                
                xor eax, eax
                xor ecx, ecx
                push ebx
                pop word cx
                pop word ax
                
                xor edx, edx
                shr eax, 1 ; move rightmost bit to carry flag
            jnz count_bits ; exit if eax is now 0
            
            adc dl, 0 ; count last bit
            mov ebx, ecx
            ; call printf() to display the result
            ; int printf(const char * format, variable_1, constant_2, ...);
            push dword edx
            push dword binaryformat
            call _printf
            add esp, 4 * 2  ; clean-up the stack
            
            ; call printf() to display the result
            ; int printf(const char * format, variable_1, constant_2, ...);
            push dword space
            call _printf
            add esp, 4  ; clean-up the stack
            mov ecx, ebx
        loop third_loop
        
        ret
