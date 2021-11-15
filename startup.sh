#!/bin/bash

# Make trader user and give sudo access
useradd -G sudo -m trader
# Set password for trader user
passwd trader
# Set default shell for trader
usermod --shell /bin/bash trader
# Add ssh key for trader
echo Please enter id_rsa.pub key:
read id_rsa
mkdir /home/trader/.ssh/
echo $id_rsa >> /home/trader/.ssh/authorized_keys
# Create docker group and add trader user to allow non0ssh Docker
sudo groupadd docker
sudo usermod -aG docker trader
# Change to home directory
cd /home/trader
# Clone file dirs
git clone https://github.com/AlexBabescu/freqtrade_3commas.git freqtrade
# Disable password authentication
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config
# Disable root access
sudo sed -i "/^[^#]*PermitRootLogin[[:space:]]yes/c\PermitRootLogin no" /etc/ssh/sshd_config
# Restart sshd service
sudo systemctl restart sshd
# Change pemw to all files in trader home
chown -R trader /home/trader
echo Rebooting...
reboot