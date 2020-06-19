#!/bin/bash
nmap -sV 172.31.47.9 -A -v
nmap -p- 172.31.47.9
nmap --script=http-methods.nse 172.31.47.9




