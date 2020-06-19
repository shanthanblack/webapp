#!/bin/bash
nmap -sS 172.31.47.9 -O
nmap -sV 172.31.47.9 -A -v
nmap -p- 172.31.47.9
nmap --script=http-methods.nse 172.31.47.9
nmap -v -sS -A -T4 52.66.199.181



