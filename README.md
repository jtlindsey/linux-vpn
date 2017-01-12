# linux-vpn
A Linux VPN script for the shell. 

This is a simple script that I needed when I had to frequently connect and disconnect to different customers VPN connections (using PPTP) while troubleshooting their servers and VOIP equipment. It was much quicker than clicking through the GUI in Ubuntu or Mint, and faster than Windows Rasphone. I haven't did much work on the error codes, so that part needs improvement.

To use the script you will need to make it executable (`chmod a+x jtlvpn.sh`) after downloading, manually create a vpn connection in the GUI and name it VPN for the script to find and easily tell you the connection UUID, set the `VPNUUID` in the script to match the output of the UUID from `nmcli con show | grep 'vpn'` and run with ./jtlvpn.sh or whatever you name it. 
