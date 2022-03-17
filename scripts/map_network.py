#!/usr/bin/python3
import nmap # pip install python-nmap

base_ip = '192.168.1.0/24'

def callback_result(host, scan_result):
    print ('------------------')
    print (host, scan_result)

def scan_network(base_ip_address):
    nma = nmap.PortScannerAsync()
    nma.scan(hosts=base_ip_address, arguments='-sP', callback=callback_result)
    while nma.still_scanning():
        print("Waiting >>>")
        nma.wait(2)   # you can do whatever you want but I choose to wait after the end of the scan

if __name__ == '__main__':
    scan_network(base_ip)