#!/usr/bin/env python2

def littlen(s):
    s = s.encode("hex")
    s = bytearray.fromhex(s)
    s.reverse()
    return ''.join(format(x,'02x') for x in s).upper()
    

def pushstr(s):
    s = littlen(s)
    for i in range(0, len(s),8):
        print "push " +  s[i:i+8] 



