bits 32
global start

extern exit
import exit msvcrt.dll

; a - byte, b - word, c - double word, d - qword - Unsigned representation
; (d+d)-(a+a)-(b+b)-(c+c)

segment data use32 class=data
    a db 1
    b dw 2
    c dd 3
    d dq 10

segment code use32 class=code
start:
    mov eax, dword [d]
    mov edx, dword [d+4] ; edx:eax = d
    add eax, dword [d]
    adc edx, dword [d+4] ; edx:eax = d+d
    
    mov bl, [a] ; bl = a
    add bl, [a] ; bl = a+a
    mov bh, 0 ; bx = a+a
    mov cx, 0 ; cx:bx = a+a
    push cx
    push bx
    pop ebx ; ebx = a+a
    mov ecx, 0 ; ecx:ebx = a+a
    
    sub eax, ebx
    sbb edx, ecx ; edx:eax = (d+d)-(a+a)
    
    mov bx, [b] ; bx = b
    add bx, [b] ; bx = b+b
    mov cx, 0 ; cx:bx = b+b
    push cx
    push bx
    pop ebx ; ebx = b+b
    mov ecx, 0 ; ecx:ebx = b+b
    
    sub eax, ebx
    sbb edx, ecx ; edx:eax = (d+d)-(a+a)-(b+b)
    
    mov ebx, [c]
    add ebx, [c] ; ebx = c+c
    mov ecx, 0 ; ecx:ebx = c+c
    
    sub eax, ebx
    sbb edx, ecx ; edx:eax = (d+d)-(a+a)-(b+b)-(c+c)
    
    ; exit(0)
    push dword 0
    call [exit]
