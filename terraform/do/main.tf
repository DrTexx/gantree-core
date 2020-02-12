data "digitalocean_ssh_key" "default" {
  name = "gantree-digitalocean"
}

resource "digitalocean_droplet" "web" {
  count    = var.node_count
  name     = "{{name}}-${count.index}"
  size     = var.machine_type
  image    = "ubuntu-18-04-x64"
  region   = var.zone
  ssh_keys = [data.digitalocean_ssh_key.default.id]
}

resource "digitalocean_firewall" "web" {
  name = "only-22-80-and-443"

  droplet_ids = digitalocean_droplet.web.*.id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "30333"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # outbound_rule {
  #   protocol              = "tcp"
  #   port_range            = "53" # tcp/udp
  #   destination_addresses = ["0.0.0.0/0", "::/0"]
  # }

  # outbound_rule {
  #   protocol              = "tcp"
  #   port_range            = "80" # routed HTTP
  #   destination_addresses = ["0.0.0.0/0", "::/0"]
  # }

  # outbound_rule {
  #   protocol              = "tcp"
  #   port_range            = "443" # routed HTTPS
  #   destination_addresses = ["0.0.0.0/0", "::/0"]
  # }

  # outbound_rule {
  #   protocol              = "tcp"
  #   port_range            = "30333" # default substrate port
  #   destination_addresses = ["0.0.0.0/0", "::/0"]
  # }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535" # note: allow any ports for TCP, likely requires future hardening. Bad security.
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}


# resource "digitalocean_droplet" "mywebserver" {
#   # Obtain your ssh_key id number via your account. See Document https://developers.digitalocean.com/documentation/v2/#list-all-keys
#   ssh_keys           = [12345678] # Key example
#   image              = "ubuntu-18-04-x64"
#   region             = "ams3"
#   size               = "s-1vcpu-1gb"
#   private_networking = true
#   backups            = true
#   ipv6               = true
#   name               = "mywebserver-ams3"

#   provisioner "remote-exec" {
#     inline = [
#       "export PATH=$PATH:/usr/bin",
#       "sudo apt-get update",
#       "sudo apt-get -y install nginx",
#     ]

#     connection {
#       type        = "ssh"
#       private_key = file("~/.ssh/id_rsa")
#       user        = "root"
#       timeout     = "2m"
#       asd         = var.foo
#     }
#   }
# }

# resource "digitalocean_domain" "mywebserver" {
#   name       = "www.mywebserver.com"
#   ip_address = "${digitalocean_droplet.mywebserver.ipv4_address}"
# }

# resource "digitalocean_record" "mywebserver" {
#   domain = "${digitalocean_domain.mywebserver.name}"
#   type   = "A"
#   name   = "mywebserver"
#   value  = "${digitalocean_droplet.mywebserver.ipv4_address}"
# }