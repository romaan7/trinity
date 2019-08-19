#!/bin/bash
#backup pot files to personal server because instance can shut down anytime
while true; do
 sshpass -f "/home/ubuntu/p.txt" scp -P 443 /home/ubuntu/hashcat/hashcat.potfile /home/ubuntu/JohnTheRipper/run/john.pot romaan7@ssh.blinkenshell.org:/home/romaan7/backup 
 sleep 60
done
