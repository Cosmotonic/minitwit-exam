terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

resource "digitalocean_droplet" "swarm_node_exam" {
  count    = 3
  name     = "swarm-node-${count.index + 1}-exam"
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-2gb"
  region   = "fra1"
  ssh_keys = ["41:f4:ae:da:02:74:9e:2b:8c:a6:9f:54:67:d8:b8:f8"]
  tags   = ["swarm"]
}


resource "digitalocean_droplet" "db_exam" {
  name     = "minitwit-db-exam"
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-2gb"
  region   = "fra1"
  ssh_keys = ["41:f4:ae:da:02:74:9e:2b:8c:a6:9f:54:67:d8:b8:f8"]
  tags   = ["db"]
}

resource "digitalocean_droplet" "monitoring_exam" {
  name     = "minitwit-monitoring-exam"
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-2gb"
  region   = "fra1"
  ssh_keys = ["41:f4:ae:da:02:74:9e:2b:8c:a6:9f:54:67:d8:b8:f8"]
  tags   = ["monitoring"]
}

# notidce its "data" not "resource" declaration.
# With data we look for existing volumes not crate new ones. 
data "digitalocean_volume" "volume_db_exam" {
  name   = "volume-db-exam"
  region = "fra1"
}

data "digitalocean_volume" "volume_monitoring_exam" {
  name   = "volume-monitoring-exam"
  region = "fra1"
}

resource "digitalocean_volume_attachment" "db_volume_attachment" {
  droplet_id = digitalocean_droplet.db_exam.id
  volume_id  = data.digitalocean_volume.volume_db_exam.id
}

resource "digitalocean_volume_attachment" "monitoring_volume_attachment" {
  droplet_id = digitalocean_droplet.monitoring_exam.id
  volume_id  = data.digitalocean_volume.volume_monitoring_exam.id
}




# Hver gang ny server oprettes ændres IPen. Den kan dog gemmes som value under opstart. 
output "swarm_0_ip" {
  value = digitalocean_droplet.swarm_node_exam[0].ipv4_address
}
output "swarm_1_ip" {
  value = digitalocean_droplet.swarm_node_exam[1].ipv4_address
}
output "swarm_2_ip" {
  value = digitalocean_droplet.swarm_node_exam[2].ipv4_address
}
output "db_exam" {
  value = digitalocean_droplet.db_exam.ipv4_address
}
output "monitoring_exam" {
  value = digitalocean_droplet.monitoring_exam.ipv4_address
}