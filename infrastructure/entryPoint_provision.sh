#!/bin/bash
set -e

# Gå til terraform folder
cd terraform

# Opret server/droplet
/mnt/c/terraform/terraform.exe apply -auto-approve

# Hent public IP fra terraform output
IP=$(/mnt/c/terraform/terraform.exe output -raw droplet_ip)

# Generer ansible inventory automatisk
echo "[minitwit-exam]" > ../ansible/inventory.ini
echo "$IP ansible_user=root" >> ../ansible/inventory.ini

# Vent på at serveren booter færdigt
echo "Waiting for server..."
sleep 15

# Gå til ansible folder
cd ../ansible

# Provision server + deploy containers
ansible-playbook -i inventory.ini playbook.yml