bits 32

global start        

extern exit, printf, scanf, fopen, fclose, fread, fprintf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    input_descriptor dd -1
    file_prompt db "Input file name: ", 0
    file times 256 db 0
    file_format db "%s", 0
    
    character_prompt db "Special character: ", 0
    character resb 1
    character_format db "%s", 0
    
    number_prompt db "Number: ", 0
    number resb 1
    number_format db "%d", 0
    
    write_mode db "w", 0
    read_mode db "r", 0
    
    output db "output.txt", 0
    output_descriptor dd -1
    
    len equ 255
    read_lines times (len+1) db 0
    
    read_len resd 1
    checked_last db 0
    quit_text db 10, "INFO: Quitting.", 0
    
segment code use32 class=code
    read_console:
        push dword file_prompt ; push the file prompt
        call [printf] ; print the file prompt
        add esp, 4 ; clean up the stack
        
        push file ; push the file name variable
        push file_format ; push the reading format
        call [scanf] ; read from console
        add esp, 4*2 ; clean up the stack
        
    
        push dword character_prompt ; push the character prompt
        call [printf] ; print the character prompt
        add esp, 4 ; clean up the stack
        
        push character ; push the character variable
        push character_format ; push the reading format
        call [scanf] ; read from console
        add esp, 4*2 ; clean up the stack
        
        
        push dword number_prompt ; push the number prompt
        call [printf] ; print the number prompt
        add esp, 4 ; clean up the stack
        
        push number ; push the number variable
        push number_format ; push the number format
        call [scanf] ; read from console
        add esp, 4*2 ; clean up the stack
        
        ret
    
    read_file:
        push dword read_mode ; push the read mode
        push dword file ; push the file name
        call [fopen] ; open the file
        add esp, 4*2 ; clean up the stack
        
        cmp eax, 0 ; check if the file exists
        je end_program ; if the file does not exist then end the program
        mov [input_descriptor], eax ; move the input descriptor to the variable
        
        
        push dword [input_descriptor] ; push the input descriptor
        push dword len ; push the maximum length of read characters
        push dword 1 ; push the number of bytes per character
        push dword read_lines ; push the variable that stores the read string
        call [fread] ; read from the file
        add esp, 4*4 ; clean up the stack
        
        
        push dword [input_descriptor] ; push the input descriptor
        call [fclose] ; close the file
        add esp, 4 ; clean up the stack
        
        ret
    
    write_file:
        push dword write_mode ; push the write mode
        push dword output ; push the output file name
        call [fopen] ; open the file
        add esp, 4*2 ; clean up the stack
        
        mov [output_descriptor], eax ; move the file descriptor to the variable
        
        
        push dword read_lines ; push the character
        push dword [output_descriptor] ; push the file descriptor
        call [fprintf] ; write to file
        add esp, 4*2 ; clean up the stack
        
        
        push dword [output_descriptor] ; push the output descriptor
        call [fclose] ; close the file
        add esp, 4 ; clean up the stack
        
        ret
    
    strlen:
        mov [read_len], dword 0 ; initialize with size 0
        mov edi, 0 ; current string index
        strlen_loop:
            mov al, [read_lines+edi] ; move the current char to al
            cmp al, 0 ; compare al with the null char (terminator)
            je strlen_end ; if equal, stop counting
            
            inc dword [read_len] ; increase counter
            inc edi ; increase string index
        jmp strlen_loop
        
        strlen_end:
        ret
    
    start:
        ; START READING FROM CONSOLE
        
        call read_console
        
        ; END READING FROM CONSOLE
        ; START READING FROM FILE
        
        call read_file
        call strlen
        
        ; END READING FROM FILE
        ; START LOOP
        
        mov esi, 0 ; string index
        mov dl, 1 ; initialize the current word index with 1
        loop_string:
            cmp [checked_last], byte 1 ; check if we handled the last word already
            je skip_loop ; if yes, quit the loop
            
            mov al, [read_lines+esi] ; move the current character to al
            
            cmp al, 0 ; check if the character is a string terminator
            je skip_loop ; if we have reached the end of the string go to the end of the loop
            
            cmp al, 32 ; check if the character is a space
            jne checks ; if not, go to the checks
            
            ; CALCULATE NUMBER OF EXTRA CHARS TO ADD
            calcs:
            dec dl ; we are on a space so substract 1
            
            mov bl, [number]
            sub bl, dl ; substract the current word index from the given index of the special character
            
            cmp bl, 1 ; check if we need to add any new special characters
            jl next_word ; if not, jump to the next word
            
            
            ; ADD BL EXTRA SPECIAL CHARACTERS AT THE CURRENT ESI POSITION
            movzx ebx, byte bl ; extend bl
            mov ecx, [read_len] ; move the current string length to ecx
            dec ecx ; decrease by one for the correct index during the loop

            resize: ; loop backwards
                cmp ecx, esi ; check if we have reached the current esi position
                jl stop_resize ; if yes, we do not need to resize anymore
                
                mov edi, ecx ; move the character at the ecx position into edi
                mov al, [read_lines+ecx] ; move the character into al
                
                add edi, ebx ; add the amount of characters we need to extend to edi
                mov [read_lines+edi], al ; move the character to the new index
            loop resize
            stop_resize:
            
            call strlen ; get the new string length
            
            mov al, [character] ; move the special character to al
            mov ecx, ebx ; move the amount of characters we need to add into ecx
            insert:
                mov [read_lines+esi], al ; move the special character to the extended index
                
                inc esi ; increment the current index
            loop insert
            
            
            next_word:
            mov dl, 0 ; reset the current word index
            jmp continue ; continue because we do not need to check for the index this iteration
            
            checks:
            ; DO THE CHECKS
            cmp dl, [number] ; compare al to the 
            jne continue ; if we haven't reached the correct index, continue
            
            mov al, [character] ; if we did, move the special character into al
            mov [read_lines+esi], al ; move al into the correct position
            
            continue: ; next iteration of the loop
            inc esi ; increment string index
            inc dl ; increment the current word index
        jmp loop_string
        skip_loop:
        
        cmp [checked_last], byte 1 ; check if the last word has been handled
        mov [checked_last], byte 1 ; set the flag to true in any case
        jne calcs ; if the word has not been handled, handle it
        
        ; END LOOP
        call write_file
        
        end_program: ; define a label for the end of the program in case the provided input file does not exist
        
        push dword quit_text ; push the quit text
        call [printf] ; print the quit text
        add esp, 4 ; clean up the stack
        
        push dword 0
        call [exit]
