bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c - byte, d - word
; (50-b-c)*2+a*a+d

segment data use32 class=data
    a db 2
    b db 15
    c db 25
    d dw 10

segment code use32 class=code
start:
    mov eax, 0
    mov ebx, 0
    
    mov al, 50
    sub al, [b]
    sub al, [c]
    mov ah, 2
    mul ah
    
    mov bx, ax
    mov al, [a]
    mov ah, [a]
    mul ah
    
    add bx, ax
    add bx, [d]
    
    ; exit(0)
    push dword 0
    call [exit]
