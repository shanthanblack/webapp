#!/bin/bash
nmap -sV 13.232.120.52 -A -v
nmap -p 445 -script=smb-vuln-ms17-010.nse 172.31.40.63


