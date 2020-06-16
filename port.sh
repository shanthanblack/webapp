#!/bin/bash
nmap -sV 13.232.120.52 -A -v
nmap -p 445 -script=smb-vuln-ms17-010.nse 13.232.120.152
nmap --script smb-vuln-ms17-010.nse -p 445 13.232.120.152 --script-args=unsafe=1


