#1/bin/bash

sudo sed -i "4,9d" /etc/wpa_supplicant/wpa_supplicant.conf
sudo sed -i "4s/.*//" /etc/dhcpcd.conf
sudo sed -i "5s/.*//" /etc/dhcpcd.conf
sudo sed -i "6s/.*//" /etc/dhcpcd.conf
wpa_passphrase $1 $2 | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null 
sudo systemctl disable hostapd dnsmasq
sudo reboot
