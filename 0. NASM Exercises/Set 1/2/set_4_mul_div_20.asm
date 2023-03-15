bits 32
global start

extern exit
import exit msvcrt.dll

; a,b,c,d-byte, e,f,g,h-word
; [(a+b+c)*2]*3/g

segment data use32 class=data
    a db 1
    b db 3
    c db 5
    g dw 2

segment code use32 class=code
start:
    mov eax, 0
    mov ebx, 0
    
    mov al, [a]
    add al, [b]
    add al, [c]
    mov ah, 2
    mul ah
    
    mov bx, 3
    mul bx ; RESULT IN DX:AX
    
    mov bx, [g]
    div bx ; AX = DX:AX / BX, DX = DX:AX % BX
    
    ; exit(0)
    push dword 0
    call [exit]
