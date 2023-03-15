bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c,d - word
; (b+b)-c-(a+d)

segment data use32 class=data
    a dw 20
    b dw 100
    c dw 90
    d dw 30

segment code use32 class=code
start:
    mov eax, 0
    
    mov ax, [b]
    add ax, [b]
    
    mov bx, [a]
    add bx, [d]
    
    sub ax, [c]
    sub ax, bx
    
    ; exit(0)
    push dword 0
    call [exit]
