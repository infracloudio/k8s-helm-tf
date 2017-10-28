resource "digitalocean_droplet" "k8s-master-droplet" {
  image  = "${var.do-image}"
  name   = "master"
  region = "${var.do-region}"
  size   = "${var.k8s-master-size}"
  tags = ["${digitalocean_tag.master-tag.name}"]
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("${var.private_key_file}")}"
    timeout = "5m"
    agent = false
  }

  provisioner "file" {
    source = "${path.module}/scripts/master.sh"
    destination = "/tmp/master.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/master.sh",
      "/tmp/master.sh ${var.k8s-token}",
      "cat /etc/kubernetes/admin.conf"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_file} root@${digitalocean_droplet.k8s-master-droplet.ipv4_address}:/etc/kubernetes/admin.conf ."
  }
}

resource "digitalocean_droplet" "k8s-node-droplet"{
  count = "${var.k8s-node-count}"
  name = "node${count.index + 1}"
  image = "${var.do-image}"
  region = "${var.do-region}"
  size = "${var.k8s-node-size}"
  tags = ["${digitalocean_tag.node-tag.name}"]
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("${var.private_key_file}")}"
    timeout = "5m"
    agent = false
  }

  provisioner "file" {
    source = "${path.module}/scripts/node.sh"
    destination = "/tmp/node.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/node.sh",
      "/tmp/node.sh ${var.k8s-token} ${digitalocean_droplet.k8s-master-droplet.ipv4_address}"
    ]
  }
}
