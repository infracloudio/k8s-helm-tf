output "k8s-master-public-ip" {
  value = "${digitalocean_droplet.k8s-master-droplet.ipv4_address}"
}

output "k8s-node-public-ip"{
  value = "${digitalocean_droplet.k8s-node-droplet.*.ipv4_address}"
}

output "k8s-node-count" {
  value = "${var.k8s-node-count}"
}

output "kube_config_file" {
  value = "${var.kube_config_file}"
}