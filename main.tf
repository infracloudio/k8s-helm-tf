module "do-k8s-cluster" {
  source = "./k8s-do-tf"
  do_token = "${var.do_token}"
  k8s-token = "${var.kubeadm_token}"
  private_key_file = "${var.private_key_file}"
  public_key_file = "${var.public_key_file}"

}


module "gb-app" {
  source = "./gb-module"
  #frontend_image = "harshals/gb-frontend:1.0"
  frontend_replicas = "${var.fe_replicas}"
  kube_config_file = "${module.do-k8s-cluster.kube_config_file}"
}
