bits 32
global start

extern exit
import exit msvcrt.dll

; a-word; b,c,d-byte; e-doubleword; x-qword - Unsigned representation
; (a*2+b/2+e)/(c-d)+x/a
; 10/2+6=11

segment data use32 class=data
    a dw 2
    b db 4
    c db 8
    d db 6
    e dd 4
    x dq 12

segment code use32 class=code
start:
    mov ax, 2
    mul word [a] ; dx:ax = a*2
    push dx
    push ax
    pop ecx ; ecx = a*2
    
    mov al, [b]
    mov ah, 0 ; ax = b
    mov bl, 2
    div bl ; al = b/2
    mov ah, 0 ; ax = b/2
    mov dx, 0 ; dx:ax = b/2
    push dx
    push ax
    pop ebx ; ebx = b/2
    
    add ecx, ebx ; ecx = a*2+b/2
    add ecx, [e] ; ecx = (a*2+b/2+e)
    
    mov eax, ecx ; eax = (a*2+b/2+e)
    mov bl, [c] ; bl = c
    sub bl, [d] ; bl = c-d
    mov bh, 0 ; bx = c-d
    div bx ; dx:ax = (a*2+b/2+e)/(c-d)
    
    push dx
    push ax ; will come back to (a*2+b/2+e)/(c-d) later
    
    mov eax, dword [x]
    mov edx, dword [x+4] ; edx:eax = x
    
    mov bx, [a]
    mov cx, 0 ; cx:bx = a
    push cx
    push bx
    pop ebx ; ebx = a
    div ebx ; eax = x/a
    
    pop ebx ; coming back to (a*2+b/2+e)/(c-d)
    add ebx, eax ; ebx = (a*2+b/2+e)/(c-d)+x/a

    ; exit(0)
    push dword 0
    call [exit]
