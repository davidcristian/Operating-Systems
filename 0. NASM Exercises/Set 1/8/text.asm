bits 32

global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

; Two natural numbers a and b (a, b: dword, defined in the data segment) are given. Calculate their product and display the result in the following format: "<a> * <b> = <result>".
; Example: "2 * 4 = 8"
; The values will be displayed in decimal format (base 10) with sign.

segment data use32 class=data
    a dd -4
    b dd 6
    format db "%d * %d = %d", 0

segment code use32 class=code
start:
    mov eax, [a]    ; move a into eax
    mov ebx, [b]    ; move b into ebx
    imul ebx        ; do the signed multiplication, result in edx:eax
    
    ; call printf() to display the result
    ; int printf(const char * format, variable_1, constant_2, ...);
    push dword eax
    push dword [b]
    push dword [a]
    
    push dword format
    call [printf]
    add esp, 4 * 4  ; clean-up the stack
    
    ; exit(0)
    push dword 0      
    call [exit]
