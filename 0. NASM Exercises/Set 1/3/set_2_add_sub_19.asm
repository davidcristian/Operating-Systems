bits 32
global start

extern exit
import exit msvcrt.dll

; a - byte, b - word, c - double word, d - qword - Signed representation
; (d+a)-(c-b)-(b-a)+(c+d)

segment data use32 class=data
    a db 1
    b dw 2
    c dd 6
    d dq 4

segment code use32 class=code
start:
    mov ax, [b]
    cwde ; eax = b
    
    mov ebx, [c]
    sub ebx, eax ; ebx = c-b
    
    mov al, [a]
    cbw ; ax = a
    
    mov cx, [b]
    sub cx, ax ; cx = b-a
    mov ax, cx ; ax = b-a
    cwde ; eax = b-a
    
    add ebx, eax ; ebx = (c-b)-(b-a) (we use addition because we have a minus before these 2 operations and we are calculating it separately)
    push ebx ; save to stack
    
    mov al, [a]
    cbw ; ax = a
    cwde ; eax = a
    cdq ; edx:eax = a
    
    add eax, dword [d]
    adc edx, dword [d+4] ; edx:eax = d+a
    
    mov ebx, eax
    mov ecx, edx ; ecx:ebx = d+a
    
    pop eax ; restore (c-b)-(b-a)
    cdq ; edx:eax = (c-b)-(b-a)
    
    sub ebx, eax
    sbb ecx, edx ; ecx:ebx = (d+a)-(c-b)-(b-a)
    
    mov eax, [c]
    cdq ; edx:eax = c
    
    add eax, dword [d]
    adc edx, dword [d+4] ; edx:eax = c+d    
    
    add ebx, eax
    adc ecx, edx ; ecx:ebx = (d+a)-(c-b)-(b-a)+(c+d)
    
    ; exit(0)
    push dword 0
    call [exit]
