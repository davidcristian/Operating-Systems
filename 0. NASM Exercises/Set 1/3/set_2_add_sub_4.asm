bits 32
global start

extern exit
import exit msvcrt.dll

; a - byte, b - word, c - double word, d - qword - Signed representation
; (b+b)-c-(a+d)

segment data use32 class=data
    a db 2
    b dw 10
    c dd 2
    d dq 4

segment code use32 class=code
start:
    mov ax, [b]
    add ax, [b] ; ax = b+b
    cwde ; eax = b+b
    cdq ; edx:eax = b+b
    
    mov ecx, edx
    mov ebx, eax ; ecx:ebx = b+b
    
    mov eax, [c]
    cdq ; edx:eax = c
    
    sub ebx, eax
    sbb ecx, edx ; ecx:ebx = (b+b)-c
    
    mov al, [a]
    cbw ; ax = a
    cwde ; eax = a
    cdq ; edx:eax = a
    
    add eax, dword [d]
    adc edx, dword [d+4] ; edx:eax = a + d
    
    sub ebx, eax
    sbb ecx, edx ; ecx:ebx = (b+b)-c-(a+d)
    
    ; exit(0)
    push dword 0
    call [exit]
