# Introduction
This repository can be used to spin a Kubernetes cluster on DigitalOcean with very little effort.
The overall flow is taken from [Janakiram MSV's tutorial](https://thenewstack.io/tutorial-run-multi-node-kubernetes-cluster-digitalocean/)

# Steps

* Clone this repository
* Generate a Kubeadm token using following command:
`python -c 'import random; print "%0x.%0x" % (random.SystemRandom().getrandbits(3*8), random.SystemRandom().getrandbits(8*8))'`
* Create a file called terraform.tfvars with following content:
~~~
do_token = "YOUR_DIGITALOCEAN_TOKEN"

# Generate a new token via following command line:
# python -c 'import random; print "%0x.%0x" % (random.SystemRandom().getrandbits(3*8), random.SystemRandom().getrandbits(8*8))'
#
k8s-token = "USE_TOKEN_FROM_PREVIOUS_STEP"

#
# Location of public and private key files
#
private_key_file = "ssh/harshal-ic.ppk"
public_key_file = "ssh/harshal-ic-pub.txt"
~~~
* Run `terraform apply`. Once the process finishes, 1 master and 2(default) workers will be created and admin.conf to work with kubernetes cluster will get copied to the PWD location.

**Note:** Variables defined in variables.tf can be overwritten by updating them in terraform.tfvars

* Once the process finishes, run following command to work with your kubernetes cluster:
`kubectl --kubeconfig ./admin.conf get nodes`