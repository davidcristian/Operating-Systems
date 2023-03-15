bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c,d - byte
; (a+a)-(c+b+d)

segment data use32 class=data
    a db 4
    b db 1
    c db 3
    d db 2

segment code use32 class=code
start:
    mov eax, 0

    mov al, [a]
    add al, [a]
    
    mov bl, [c]
    add bl, [b]
    add bl, [d]
    
    sub al, bl
    
    ; exit(0)
    push dword 0
    call [exit]
