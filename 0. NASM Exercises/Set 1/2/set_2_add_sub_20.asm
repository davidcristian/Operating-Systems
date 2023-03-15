bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c,d - word
; b-(b+c)+a

segment data use32 class=data
    a dw 30
    b dw 200
    c dw 20

segment code use32 class=code
start:
    mov eax, 0
    
    mov ax, [b]
    
    mov bx, [b]
    add bx, [c]
    
    sub ax, bx
    add ax, [a]
    
    ; exit(0)
    push dword 0
    call [exit]
