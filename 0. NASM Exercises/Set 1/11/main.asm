bits 32

import exit msvcrt.dll
import printf msvcrt.dll

extern exit, printf, decimal, hex, binary
global start

; 4. A string of numbers is given. Show the values in base 16 and base 2. 

segment data use32 class=data
    numbers dd 10, 11, 12, 13, 14, 15, 16, 17, 18
    len equ ($-numbers)/4
    
    newline dd 10
    space dd 32

; our code starts here
segment code use32 class=code
    start:
        call decimal
        call hex
        call binary
        
        ; exit(0)
        push dword 0
        call [exit]
