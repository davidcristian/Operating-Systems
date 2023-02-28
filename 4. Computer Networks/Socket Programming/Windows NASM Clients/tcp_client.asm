bits 32

global start        

extern exit, printf, scanf, WSAStartup, WSACleanup, socket, closesocket, connect, send, recv, inet_addr, htons, htonl, ntohl
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

import WSAStartup Ws2_32.dll
import WSACleanup Ws2_32.dll
import socket Ws2_32.dll
import closesocket Ws2_32.dll
import connect Ws2_32.dll
import send Ws2_32.dll
import recv Ws2_32.dll

import inet_addr Ws2_32.dll
import htons Ws2_32.dll

import htonl Ws2_32.dll
import ntohl Ws2_32.dll

segment data use32 class=data
    ; STRINGS
    welcome_msg db "TCP client", 10, 0
    quit_msg db "INFO: Quit", 10, 0

    WSAStartup_error db "ERROR: WSAStartup()", 10, 0
    socket_error db "ERROR: socket()", 10, 0
    connect_error db "ERROR: connect()", 10, 0
    send_error db "ERROR: send()", 10, 0
    recv_error db "ERROR: recv()", 10, 0
    
    sent_print_format db "Sent: %d", 10, 0
    received_print_format db "Got: %d", 10, 0

    ; CONSTANTS
    SERVER_IP db "127.0.0.1", 0
    SERVER_PORT dw 7777
    BUFFER_LEN equ 4        ; 4 bytes (unsigned int)
    
    WSA_VERSION dw 0202h    ; MAKEWORD(2, 2)
    AF_INET equ 2
    SOCK_STREAM equ 1
    IPPROTO_TCP equ 6
    
    INVALID_SOCKET equ ~0   ; UNSIGNED
    SOCKET_ERROR equ -1     ; SIGNED

    INFINITE equ 0FFFFFFFFh
    NULL equ 0

    ; BOOLS
    wsaStarted db 0
    sockCreated db 0
    sendError db 0

    ; WINAPI SOCKET
    SIZEOF_WSADATA equ 400
    wsaData resb SIZEOF_WSADATA
    SIZEOF_SOCKADDR equ 16
    sockAddr resb SIZEOF_SOCKADDR
    
    ; HANDLES
    sockHandle resd 1
    
    ; BUFFERS
    sendNum resd 1
    sendBuff times (BUFFER_LEN) db 0
    recvNum resd 1
    recvBuff times (BUFFER_LEN) db 0

    ; READING
    number_prompt db "Positive integer: ", 0
    number_format db "%d", 0

segment code use32 class=code
    send_fun:
        ; convert number from little endian to big endian
        push dword [sendNum]            ; sendNum
        call [htonl]                    ; htonl(sendNum)
        mov [sendBuff], eax             ; sendBuff = htonl(sendNum)
        
        push dword 0                    ; flags
        push dword BUFFER_LEN           ; BUFFER_LEN
        push dword sendBuff             ; sendBuff
        push dword [sockHandle]         ; sockHandle
        call [send]                     ; send(sockHandle, sendBuff, sizeof(sendBuff), 0)
        cmp eax, SOCKET_ERROR           ; == SOCKET_ERROR?
        je send_error_label             ; send failed, jump to error handler

        push dword [sendNum]            ; sendNum
        push dword sent_print_format    ; sent_print_format
        call [printf]                   ; printf(sent_print_format, sendNum)
        add esp, 4 * 2                  ; clean up stack, 2 dwords
        jmp send_end                    ; jump to end of send_fun

        send_error_label:
        mov [sendError], byte 1         ; send failed, cleanup will be required
        push dword send_error           ; send_error
        call [printf]                   ; printf(send_error)

        send_end:
        ret

    receive_fun:        
        loop_recv:
            ; recv
            push dword 0                ; flags
            push dword BUFFER_LEN       ; BUFFER_LEN
            push dword recvBuff         ; recvBuff
            push dword [sockHandle]     ; sockHandle
            call [recv]                 ; recv(sockHandle, recvBuff, BUFFER_LEN, 0)
            cmp eax, dword 0            ; <= 0?
            jle recv_stop               ; true, jump to handle connection closed/error
            
            ; convert number from big endian to little endian
            push dword [recvBuff]       ; recvBuff
            call [ntohl]                ; ntohl(recvBuff)
            mov [recvNum], eax          ; recvNum = ntohl(recvBuff)
            
            push dword [recvNum]                ; recvNum
            push dword received_print_format    ; received_print_format
            call [printf]                       ; printf(received_print_format, recvNum)
            add esp, 4 * 2                      ; clean up stack, 2 dwords
        jmp loop_recv
    
        recv_stop:
        cmp eax, dword 0                ; == 0?
        je recv_end                     ; true (connection closed), don't print error
        push dword recv_error           ; else, print error
        call [printf]                   ; printf(recv_error)
        add esp, 4                      ; clean up stack, 1 dword

        recv_end:
        ret
        
    start:
        ; printf and scanf use the cdecl calling convention
        ; so the stack must be cleaned up after every call
        ; the rest of the imported functions use the stdcall
        ; calling convention so stack management is not needed
        
        ; show welcome message
        push dword welcome_msg          ; welcome_msg
        call [printf]                   ; printf(welcome_msg)
        add esp, 4                      ; clean up stack, 1 dword
        
        ; read number from console
        push dword number_prompt        ; number_prompt
        call [printf]                   ; printf(number_prompt)
        add esp, 4                      ; clean up stack, 1 dword
        
        push dword sendNum              ; &sendNum
        push dword number_format        ; number_format
        call [scanf]                    ; scanf(number_format, &sendNum)
        add esp, 4 * 2                  ; clean up stack, 2 dwords
        
        ; WSAStartup
        push dword wsaData              ; wsaData
        push dword WSA_VERSION          ; WSA_VERSION
        call [WSAStartup]               ; WSAStartup(WSA_VERSION, wsaData)
        cmp eax, dword 0                ; == 0?
        je socket_create                ; true, jump to create socket
        push dword WSAStartup_error     ; else, print error
        call [printf]                   ; printf(WSAStartup_error)
        add esp, 4                      ; clean up stack, 1 dword
        jmp cleanup                     ; jump to program cleanup
        
        socket_create:
        mov [wsaStarted], byte 1        ; WSAStartup success, cleanup will be required
        ; socket
        push dword IPPROTO_TCP          ; IPPROTO_TCP
        push dword SOCK_STREAM          ; SOCK_STREAM
        push dword AF_INET              ; AF_INET
        call [socket]                   ; socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        mov [sockHandle], eax           ; save handle
        cmp eax, INVALID_SOCKET         ; != INVALID_SOCKET?
        jne socket_connect              ; true, jump to create connection
        push dword socket_error         ; else, print error
        call [printf]                   ; printf(socket_error)
        add esp, 4                      ; clean up stack, 1 dword
        jmp cleanup                     ; jump to program cleanup
        
        socket_connect:
        mov [sockCreated], byte 1       ; socket success, cleanup will be required
        ; create address
        mov [sockAddr], dword AF_INET   ; sockAddr[, , AF_INET]; short sin_family
        push dword [SERVER_PORT]        ; SERVER_PORT
        call [htons]                    ; htons(SERVER_PORT); unsigned short sin_port
        mov [sockAddr+2], word ax       ; sockAddr[, htons(SERVER_PORT), AF_INET]
        push dword SERVER_IP            ; SERVER_IP
        call [inet_addr]                ; inet_addr(SERVER_IP); unsigned long s_addr
        mov [sockAddr+4], dword eax     ; sockAddr[inet_addr(SERVER_IP), htons(SERVER_PORT), AF_INET]
        ; connect
        push dword SIZEOF_SOCKADDR      ; sizeof(sockAddr)
        push dword sockAddr             ; sockAddr
        push dword [sockHandle]         ; sockHandle
        call [connect]                  ; connect(sockHandle, sockAddr, sizeof(sockAddr))
        cmp eax, SOCKET_ERROR           ; != SOCKET_ERROR?
        jne send_label                  ; true, jump to the send label
        push dword connect_error        ; else, print error
        call [printf]                   ; printf(connect_error)
        add esp, 4                      ; clean up stack, 1 dword
        jmp cleanup                     ; jump to program cleanup
        
        send_label:
        call send_fun

        cmp [sendError], byte 1         ; == 1?
        je cleanup                      ; true (send failed), jump to cleanup
        
        receive_label:
        call receive_fun
        
        cleanup:
        ; closesocket
        cmp [sockCreated], byte 1       ; != 1?
        jne cleanup_wsa                 ; true (invalid socket), don't close the socket
        push dword [sockHandle]         ; else, do
        call [closesocket]              ; closesocket(sockHandle)
        
        cleanup_wsa:
        ; WSACleanup
        cmp [wsaStarted], byte 1        ; != 1?
        jne quit                        ; true (WSAStartup failed), jump to quit
        call [WSACleanup]               ; else, WSACleanup()
        
        push dword quit_msg             ; quit_msg
        call [printf]                   ; printf(quit_msg)
        add esp, 4                      ; clean up stack, 1 dword

        quit:
        push dword 0                    ; 0
        call [exit]                     ; exit(0)
