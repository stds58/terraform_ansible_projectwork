
resource "yandex_compute_instance" "vm" {
  name        = var.name
  platform_id = var.platform_id
  zone        = var.zone

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true # Включить NAT для доступа в интернет
    security_group_ids = var.security_group_ids
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(var.ssh_key_path)}"
  }

}

