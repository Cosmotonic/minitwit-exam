#!/bin/bash
set -e

# Gå til terraform folder
cd terraform

# Opret server/droplet
/mnt/c/terraform/terraform.exe apply -auto-approve

# Hent public IP fra terraform output
IP0=$(/mnt/c/terraform/terraform.exe output -raw swarm_0_ip)
IP1=$(/mnt/c/terraform/terraform.exe output -raw swarm_1_ip)
IP2=$(/mnt/c/terraform/terraform.exe output -raw swarm_2_ip)

IP_db=$(/mnt/c/terraform/terraform.exe output -raw db_exam)
IP_monitoring=$(/mnt/c/terraform/terraform.exe output -raw monitoring_exam)


# Generer ansible inventory automatisk
echo "[swarm]" > ../ansible/inventory.ini
echo "$IP0 ansible_user=root" >> ../ansible/inventory.ini
echo "$IP1 ansible_user=root" >> ../ansible/inventory.ini
echo "$IP2 ansible_user=root" >> ../ansible/inventory.ini

echo "$IP_db ansible_user=root" >> ../ansible/inventory.ini
echo "$IP_monitoring ansible_user=root" >> ../ansible/inventory.ini


# Vent på at serveren booter færdigt
echo "Waiting for server..."
sleep 15

# Gå til ansible folder
cd ../ansible

# Provision server + deploy containers
# ansible-playbook -i inventory.ini playbook.yml
ansible-playbook -i inventory.digitalocean.yml site.yml



# added python assert 