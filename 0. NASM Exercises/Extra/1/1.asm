bits 32

global start

extern exit, printf, scanf, fopen, fclose, fprintf, fread
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data
    character_text db "c=", 0
    special_character resb 1
    character_file_format db "%s", 0

    number_text db "n=", 0
    number resb 1
    number_file_format db "%d", 0
    
    file_text db "The file name is: ", 0
    input_file times 32 db 0
    file_format db "%s", 0
    input_descriptor dd -1

    write_mode db "w", 0
    read_mode db "r", 0
    read_file_format db "%s"
    
    output_file db "output.txt", 0
    output_descriptor dd -1

    len equ 255
    content times (len+1) db 0

segment code use32 class=code
    start:
        push dword character_text
        call [printf]
        add esp, 4 ; write the input prompt for the special_character to the console
        
        push special_character
        push character_file_format
        call [scanf]
        add esp, 4*2 ; read the special_character from the user
    
        push dword number_text
        call [printf]
        add esp, 4 ; write the input prompt for the number to the console
        
        push number
        push number_file_format
        call [scanf]
        add esp, 4*2 ; read the number from the user
    
        push dword file_text
        call [printf]
        add esp, 4 ; write the input prompt for the file name to the console
    
        push input_file
        push file_format
        call [scanf]
        add esp, 4*2 ; read the file name from the user
        
    
        push dword read_mode
        push dword input_file
        call [fopen]
        add esp, 4*2 ; open the input file in read mode
        
        mov [input_descriptor], eax ; move the descriptor to the variable
        cmp eax, 0
        je final ; jump to the end if the file does not exist
        
        push dword [input_descriptor]
        push dword len
        push dword 1
        push dword content        
        call [fread]
        add esp, 4*4 ; read all the contents of the file and store them in the content variable
        
        push dword [input_descriptor]
        call [fclose]
        add esp, 4 ; close the file
 
 
        mov esi, 0 ; initialize the string index
        mov bl, 0 ; initialize the current character count
        loop_string:
            mov al, [content+esi] ; load the current character into al`
            cmp al, 0 ; check if we have reached the end of the string
            je end_loop ; jump to the end of the loop if we did`
            
            mov ah, 0
            mov al, bl ; move the current character count into al
            div byte[number] ; divide the current character count by the number
            cmp ah, 0 ; check if the remainder is 0
            jne next_iteration ; if the number is not a multiple of n, go to the next iteration
            
            mov al, [special_character] ; move the special character to al
            mov [content+esi], al ; replace the character with the special character
            
            next_iteration:
            inc esi ; increment the counters
            inc bl
        jmp loop_string
        end_loop:
 
 
        push dword write_mode
        push dword output_file
        call [fopen]
        add esp, 4*2 ; open the output file in write mode
        
        mov [output_descriptor], eax ; open the output file and store the descriptor in output_descriptor
        
        push dword content
        push dword [output_descriptor]
        call [fprintf]
        add esp, 4*2 ; write the content to the file
        
        push dword [output_descriptor]
        call [fclose]
        add esp, 4 ; close the file
        
        final:
        push dword 0
        call [exit]
        
