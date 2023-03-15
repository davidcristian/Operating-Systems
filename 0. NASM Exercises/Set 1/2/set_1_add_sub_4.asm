bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c,d - byte
; (a-b)+(c-b-d)+d

segment data use32 class=data
    a db 4
    b db 1
    c db 7
    d db 2

segment code use32 class=code
start:
    mov eax, 0

    mov al, [a]
    sub al, [b]
    
    mov bl, [c]
    sub bl, [b]
    sub bl, [d]
    
    add al, bl    
    add al, [d]
    
    ; exit(0)
    push dword 0
    call [exit]
