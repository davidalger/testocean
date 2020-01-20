terraform {
  required_version = "~> 0.12.2"
}

# Configure the DigitalOcean provider
provider "digitalocean" {
  version = "~> 1.12"
  token   = var.digitalocean_token
}

provider "external" {
    version = "~> 1.2"
}

# Provides local shell username to Terraform for droplet naming purposes
data "external" "tfuser" {
  program = ["sh", "-c", "echo '{\"name\":\"'$(whoami)'\"}'"]
}

# Spin up variable number of droplets
resource "digitalocean_droplet" "instance" {
  count = var.droplet_count

  name = format(
    "%s-%s-%s-%s-%02d",
    replace(var.droplet_image, "/-.*/", ""),
    data.external.tfuser.result.name,
    var.droplet_size,
    var.droplet_region,
    count.index + 1
  )

  size     = var.droplet_size
  image    = var.droplet_image
  region   = var.droplet_region
  ssh_keys = var.digitalocean_fingerprints
}

# Output IPv4 addresses of each droplet by name
output "droplet_ipv4_addresses" {
  value = zipmap(digitalocean_droplet.instance.*.name, digitalocean_droplet.instance.*.ipv4_address)
}
