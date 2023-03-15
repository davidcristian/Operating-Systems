bits 32
global start

extern exit
import exit msvcrt.dll

; e-doubleword; x-qword - Signed representation
; (a+a+b*c*100+x)/(a+10)+e*a; a,b,c-byte
; 660/20+40=73

segment data use32 class=data
    a db 10
    b db 2
    c db 3
    e dd 4
    x dq 40

segment code use32 class=code
start:
    mov al, [a]
    add al, [a] ; al = a+a
    cbw ; ax = a+a
    cwde ; eax = a+a
    push eax ; save a+a
    
    mov al, [b]
    mov bl, [c]
    imul bl ; ax = b*c
    
    mov bx, 100
    imul bx ; dx:ax = b*c*100
    push dx
    push ax
    pop eax ; eax = b*c*100
    cdq ; edx:eax = b*c*100
    
    mov ecx, edx
    mov ebx, eax ; ecx:ebx = b*c*100
    pop eax ; eax = a+a
    cdq ; edx:eax = a+a
    
    add ebx, eax
    adc ecx, edx ; ecx:ebx = a+a+b*c*100
    add ebx, dword [x]
    adc ecx, dword [x+4] ; (a+a+b*c*100+x)
    
    push ecx
    push ebx ; save (a+a+b*c*100+x)
    
    mov al, [a]
    add al, 10 ; al = a+10
    cbw ; ax = a+10
    cwde ; eax = a+10
    mov ebx, eax ; ebx = a+10
    
    pop eax
    pop edx ; retrieve (a+a+b*c*100+x)
    idiv ebx ; eax = (a+a+b*c*100+x)/(a+10)
    push eax ; save (a+a+b*c*100+x)/(a+10)
    
    mov al, [a]
    cbw ; ax = a
    cwde ; eax = a
    
    mov ebx, [e]
    imul ebx ; edx:eax = e*a
    
    mov ebx, eax
    mov ecx, edx ; ecx:ebx = e*a
    
    pop eax ; retrieve (a+a+b*c*100+x)/(a+10)
    cwde ; edx:eax = (a+a+b*c*100+x)/(a+10)
    
    add eax, ebx
    adc edx, ecx ; edx:eax = (a+a+b*c*100+x)/(a+10)+e*a
    
    ; exit(0)
    push dword 0
    call [exit]
