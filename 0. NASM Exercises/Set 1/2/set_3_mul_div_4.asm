bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c - byte, d - word
; –a*a + 2*(b-1) – d

segment data use32 class=data
    a db 2
    b db 2
    d dw 20

segment code use32 class=code
start:
    mov eax, 0
    mov ebx, 0
    
    mov al, [a]
    neg al
    mov ah, [a]
    mul ah
    
    mov bx, ax
    
    mov al, 2
    mov ah, [b]
    dec ah
    mul ah
    
    add bx, ax
    sub bx, [d]

    ; exit(0)
    push dword 0
    call [exit]
