bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c,d-byte, e,f,g,h-word
; (a-c)*3+b*b

segment data use32 class=data
    a db 5
    b db 2
    c db 3

segment code use32 class=code
start:
    mov eax, 0
    mov ebx, 0
    
    mov al, [a]
    sub al, [c]
    mov ah, 3
    mul ah
    
    mov bx, ax
    mov al, [b]
    mov ah, [b]
    mul ah
    
    add bx, ax
    
    ; exit(0)
    push dword 0
    call [exit]
