terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=1.8.4" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  host = "ssh://ubunter@158.160.6.215"
}

#однострочный комментарий

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "mysql_8" {
  name = "mysql:8"
}

resource "docker_volume" "mysql_data" {
  name = "mysql_data"
}
resource "docker_container" "mysql" {
  image = docker_image.mysql_8.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 3306
    external = 3306
  }
  
  env = [
    "MYSQL_ROOT_PASSWORD=${var.PASS_ROOT}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${var.PASS_USR_SQL}",
    "MYSQL_ROOT_HOST=%"
  ]
  
  mounts {
    target = "/var/lib/mysql"
    source = docker_volume.mysql_data.name
    type   = "volume"
  }
}

variable "PASS_ROOT" {
  description = "Root password for MySQL"
}

variable "PASS_USR_SQL" {
  description = "User password for MySQL"
}

