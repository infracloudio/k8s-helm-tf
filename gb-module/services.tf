resource "kubernetes_service" "redis-master" {
  metadata {
    name = "redis-master"
  }
  spec {
    selector {
      app = "redis"
      role = "master"
      tier = "backend"
    }
    port {

      port = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_service" "redis-slave" {
  metadata {
    name = "redis-slave"
  }
  spec {
    selector {
      app = "redis"
      role = "slave"
      tier = "backend"
    }
    port {
      port = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_service" "redis-fe" {
  metadata {
    name = "redis-fe"
  }
  spec {
    selector {
      app = "guestbook"
      tier = "frontend"
    }
    port {
      port = 80
      node_port = "${var.frontend_node_port}"
      target_port = 80

    }
    type = "NodePort"
  }
}