#!/bin/bash

# Display listening sockets with their PID and program name

# Check if user has root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Display listening TCP sockets
echo "Active Internet connections (only servers)"
echo "Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name"
netstat -tuln | grep '^tcp' | awk '{print $1,$4,$5,$6}' | while read proto recvq sendq local foreign state; do
    pid=$(lsof -i "${local#*:}" | awk 'NR==2{print $2}')
    program=$(lsof -i "${local#*:}" | awk 'NR==2{print $1}')
    echo "$proto $recvq $sendq $local $foreign $state $pid/$program"
done

# Display listening UDP sockets
netstat -uln | grep '^udp' | awk '{print $1,$4,$5}' | while read proto recvq sendq local foreign; do
    pid=$(lsof -i "${local#*:}" | awk 'NR==2{print $2}')
    program=$(lsof -i "${local#*:}" | awk 'NR==2{print $1}')
    echo "$proto $recvq $sendq $local $foreign $pid/$program"
done

# Display active UNIX domain sockets
echo "Active UNIX domain sockets (only servers)"
echo "Proto RefCnt Flags       Type       State         I-Node   PID/Program name    Path"
netstat -lx | grep '^unix' | awk '{print $1,$2,$3,$4,$5,$6,$7,$8}'
