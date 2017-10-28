resource "digitalocean_ssh_key" "default" {
  name       = "k8s-ssh-key"
  public_key = "${file("${var.public_key_file}")}"
}

resource "digitalocean_tag" "master-tag" {
  name = "k8s-master"
}

resource "digitalocean_tag" "node-tag" {
  name = "k8s-node"
}
