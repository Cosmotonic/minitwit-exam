terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

resource "digitalocean_droplet" "minitwit-exam" { 
  count    = 1 
  name     = "node-${count.index}" 
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-1gb"
  region   = "fra1"
  tags   = ["swarm"]
  ssh_keys = ["41:f4:ae:da:02:74:9e:2b:8c:a6:9f:54:67:d8:b8:f8"]
}

# Hver gang ny server oprettes ændres IPen. Den kan dog gemmes som value under opstart. 
output "droplet_ip" {
  value = digitalocean_droplet.minitwit-exam[0].ipv4_address
}