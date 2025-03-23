
module "network" {
  source    = "./modules/network"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  name = "project_work_network"
}

module "subnetwork" {
  source    = "./modules/subnet"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  subnet_name    = "project_work_subnetwork"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = module.network.network_id
}

module "security_groups_vm1" {
  source = "./modules/security-groups"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  network_id          = module.network.network_id
  security_group_name = "sg-vm1"
  ingress_rules = [
    {
      protocol       = "tcp"
      port           = 22
      v4_cidr_blocks = ["0.0.0.0/0"] # Разрешаем SSH-доступ с любого IP
    }
  ]
}

module "security_groups_vm2" {
  source = "./modules/security-groups"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  network_id          = module.network.network_id
  security_group_name = "sg-vm2"
  ingress_rules = [
    {
      protocol       = "tcp"
      description    = "Allow SSH from vm1"
      port           = 22
      v4_cidr_blocks = ["${module.vm1.internal_ip_address}/32"] # Доступ к VM2 только из VM1
    }
  ]
}

module "security_groups_vm3" {
  source = "./modules/security-groups"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  network_id          = module.network.network_id
  security_group_name = "sg-vm3"
  ingress_rules = [
    {
      protocol       = "tcp"
      description    = "Allow SSH from vm1"
      port           = 22
      v4_cidr_blocks = ["${module.vm1.internal_ip_address}/32"] # Доступ к VM3 только из VM1
    }
  ]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

data "yandex_compute_image" "centos8" {
  family = "centos-stream-8"
}

module "vm1" {
  source    = "./modules/instance"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  name          = "vm1"
  platform_id   = "standard-v3" # Intel Ice Lake
  zone          = "ru-central1-a"
  cores         = 2
  memory        = 2
  core_fraction = 100
  image_id      = data.yandex_compute_image.ubuntu.id
  disk_size     = 20
  disk_type     = "network-ssd"
  subnet_id     = module.subnetwork.subnet_id
  security_group_ids = [module.security_groups_vm1.security_group_id]
  ssh_key_path  = "~/.ssh/terraform_20250320.pub"
  metadata = {
    ssh-keys  = "ubuntu:${file(var.ssh_key_path)}"
  }

  labels = {
  environment = "app-dev"
  terraform   = "true"
  role        = "web"
  role        = "database"
  }
}

module "vm2" {
  source    = "./modules/instance"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  name          = "vm2"
  platform_id   = "standard-v3" # Intel Ice Lake
  zone          = "ru-central1-a"
  cores         = 2
  memory        = 2
  core_fraction = 100
  image_id      = data.yandex_compute_image.ubuntu.id
  disk_size     = 20
  disk_type     = "network-ssd"
  subnet_id     = module.subnetwork.subnet_id
  security_group_ids = [module.security_groups_vm1.security_group_id]
  ssh_key_path  = "~/.ssh/terraform_20250320.pub"
  metadata = {
    ssh-keys  = "ubuntu:${file(var.ssh_key_path)}"
  }
  labels = {
  environment = "app-dev"
  terraform   = "true"
  role        = "app"
  }
}

module "vm3" {
  source    = "./modules/instance"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  token     = var.token

  name          = "vm3"
  platform_id   = "standard-v3" # Intel Ice Lake
  zone          = "ru-central1-a"
  cores         = 2
  memory        = 2
  core_fraction = 100
  image_id      = data.yandex_compute_image.centos8.id
  disk_size     = 20
  disk_type     = "network-ssd"
  subnet_id     = module.subnetwork.subnet_id
  security_group_ids = [module.security_groups_vm1.security_group_id]
  ssh_key_path  = "~/.ssh/terraform_20250320.pub"
  metadata = {
    ssh-keys  = "cloud-user:${file(var.ssh_key_path)}"
  }
  labels = {
  environment = "app-dev"
  terraform   = "true"
  role        = "app"
  }
}

# Provisioner для копирования приватного ключа на vm1
resource "null_resource" "copy_private_key_to_vm1" {
  depends_on = [module.vm1]

  connection {
    type        = "ssh"
    host        = module.vm1.external_ip_address
    user        = "ubuntu"
    private_key = file("C:/Users/valar/.ssh/terraform_20250320")
  }

  provisioner "file" {
    source      = "C:/Users/valar/.ssh/terraform_20250320"
    destination = "/home/ubuntu/.ssh/terraform_20250320"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/terraform_20250320",
      "chown ubuntu:ubuntu /home/ubuntu/.ssh/terraform_20250320"
    ]
  }
}


