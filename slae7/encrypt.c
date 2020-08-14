#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#define BS 16    //size of the blocks 
#define arrayLength(array) (sizeof((array))/sizeof((array)[0]))


#define CBC 1
#define CTR 0
#define ECB 0

#include "aes.h"

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




uint8_t*  pad(uint8_t *raw, int size) {
    int npad;
    size = size-1; //doesnt consider null byte at the end
    npad  = (BS - size % BS);
    //if it's padded return it 
    if ((npad % BS) ==  0) {
        return raw;
    }
    //otherwise, pad it   

    int size_to_alloc = size + sizeof(uint8_t)*npad;
    uint8_t *padded = malloc(size_to_alloc);
    memcpy(padded, raw, size);
    int i = 0;
    for(i = size; i <= size_to_alloc; i++) {
        padded[i] = (uint8_t) npad ;
    }   
    
    return padded;
}


void main() {
    
    uint8_t key[16] = "\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41";
    printf("======= KEY: =======\n\n");
    ptohex(key, 16);
    printf("\n\n");
    uint8_t raw[] = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";
    uint8_t *padded;
    padded = pad(raw, arrayLength(raw));
    int nsize;
    nsize  =(arrayLength(raw)-1) +  (BS - (arrayLength(raw)-1) % BS);
    printf("====== BUFFER PADDED: =======\n\n");
    ptohex(padded, nsize);
    printf("\n\n");

    uint8_t iv[]  = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f };
    printf("======= IV: =======\n\n");
    ptohex(iv, 16);
    printf("\n\n");

    struct AES_ctx ctx;

    AES_init_ctx_iv(&ctx, key, iv);
    
    AES_CBC_encrypt_buffer(&ctx, padded, nsize);

    printf("\n\n======== CBC encrypt: ==========\n\n");
    ptohex(padded, nsize);
    printf("\n\n");


}

