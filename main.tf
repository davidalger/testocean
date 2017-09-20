terraform {
  required_version = ">= 0.10.0"
}

# Configure the DigitalOcean provider
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

# Spin up variable number of droplets
resource "digitalocean_droplet" "instance" {
  count = "${var.droplet_count}"

  name = "${format(
    "centos-%s-%s-%02d",
    var.droplet_size,
    var.droplet_region,
    count.index + 1
  )}"

  region   = "${var.droplet_region}"
  image    = "centos-7-x64"
  size     = "${var.droplet_size}"
  ssh_keys = ["${var.digitalocean_fingerprints}"]
}

# Output IPv4 addresses of each droplet by name
output "droplet_ipv4_addresses" {
  value = "${zipmap(digitalocean_droplet.instance.*.name, digitalocean_droplet.instance.*.ipv4_address)}"
}
