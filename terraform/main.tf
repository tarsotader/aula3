terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Create a new Web Droplet in the nyc1 region
resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins-vm"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

#cluster kubernets abaixo

resource "digitalocean_kubernetes_cluster" "ks8" {
  name   = "k8s"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2


  }
}


variable "ssh_key_name" {
  default = ""
}


variable "do_token" {
  default = ""
}

variable "region" {
  default = ""
}

#informacao de ip
output "jenkins_ip" {
  value = digitalocean_droplet.jenkins.ipv4_address
}


#criar arquivo local
resource "local_file" "name" {
  content = digitalocean_kubernetes_cluster.ks8.kube_config.0.raw_config 
  filename = "kube_config.yaml"

}