bits 32
extern _printf
global _decimal

segment data public data use32
    numbers dd 10, 11, 12, 13, 14, 15, 16, 17, 18
    len equ ($-numbers)/4
    
    newline dd 10
    space dd 32

    decimallabel dd "base 10: ", 0
    decimalformat dd '%d '

; our code starts here
segment code public code use32
    _decimal:
        ; call printf() to display the result
        ; int printf(const char * format, variable_1, constant_2, ...);
        push dword decimallabel
        call _printf
        add esp, 4 ; clean-up the stack
    
        mov ecx, len
        mov esi, numbers
        first_loop:
            lodsd
            
            mov ebx, ecx
            ; call printf() to display the result
            ; int printf(const char * format, variable_1, constant_2, ...);
            push dword eax
            push dword decimalformat
            call _printf
            add esp, 4 * 2  ; clean-up the stack
            mov ecx, ebx
        loop first_loop
    
        ; call printf() to display the result
        ; int printf(const char * format, variable_1, constant_2, ...);
        push dword newline
        call _printf
        add esp, 4 ; clean-up the stack
        
        ret
        