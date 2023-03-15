bits 32
global start

extern exit
import exit msvcrt.dll

; a - byte, b - word, c - double word, d - qword - Unsigned representation
; (a-b)+(c-b-d)+d

segment data use32 class=data
    a db 8
    b dw 2
    c dd 12
    d dq 4

segment code use32 class=code
start:
    mov al, [a]
    mov ah, 0 ; ax = a
    
    mov bx, [b]
    sub ax, bx ; ax = a-b
    ;------------------- will come back to AX later
    
    mov bx, [b]
    mov dx, 0 ; dx:bx = b
    push dx
    push bx
    pop ebx ; ebx = b
    
    mov ecx, [c]
    sub ecx, ebx ; ecx = c-b
    mov edx, 0 ; edx:ecx = c-b
    
    sub ecx, dword [d]
    sbb edx, dword [d+4] ; edx:ecx = c-b-d
    
    ;------------------- coming back to AX
    mov bx, 0 ; bx:ax = a-b
    push bx
    push ax
    pop eax ; eax = a-b
    mov ebx, 0 ; ebx:eax = a-b
    
    add eax, ecx
    adc ebx, edx ; ebx:eax = (a-b)+(c-b-d)
    
    add eax, dword [d]
    adc ebx, dword [d+4] ; ebx:eax = (a-b)+(c-b-d)+d
    
    ; exit(0)
    push dword 0
    call [exit]
