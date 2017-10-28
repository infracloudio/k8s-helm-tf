resource "kubernetes_replication_controller" "redis-master" {
  metadata {
    name = "redis-master-rc"
    labels {
      app = "redis"
      role = "master"
      tier = "backend"

    }
  }

  spec {
    selector {
      app = "redis"
      role = "master"
      tier = "backend"
    }
    template {
      container {
        image = "${var.redis_master_image}"
        name  = "master"
        port {
          container_port = 6379
        }
        #env{
          #name = "depends"
          #value = "${var.follows}"
        #}

        resources{
          requests{
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_replication_controller" "redis-slave" {

  metadata {
    name = "redis-slave-rc"
    labels {
      app = "redis"
      role = "slave"
      tier = "backend"

    }
  }

  spec {
    selector {
      app = "redis"
      role = "slave"
      tier = "backend"
    }
    replicas = "${var.redis_slave_replicas}"
    template {
      container {
        image = "${var.redis_slave_image}"
        name  = "slave"
        port{
          container_port = 6379
        }
        env{
          name = "GET_HOSTS_FROM"
          value = "dns"
          #name = "depends"
          #value = "${var.follows}"
        }
        resources{
          requests{
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}



resource "kubernetes_replication_controller" "frontend" {
  metadata {
    name = "frontend"
    labels {
      app = "guestbook"
      tier = "frontend"

    }
  }

  spec {
    selector {
      app = "guestbook"
      tier = "frontend"
    }
    replicas = "${var.frontend_replicas}"
    template {
      container {
        image = "${var.frontend_image}"
        name  = "php-redis"
        port {
          container_port = 80

        }
        env{
          name = "GET_HOSTS_FROM"
          value = "dns"
          name = "depends"
        }
        resources{
          requests{
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    }
  }
}
