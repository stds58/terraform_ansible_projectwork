locals {
  depends_on = [
    module.vm1,
    module.vm2,
    module.vm3,
    null_resource.copy_private_key_to_vm1
  ]
  inventory_template = templatefile("${path.module}/inventory.tpl", {
    vm1_ip = module.vm1.internal_ip_address
    vm2_ip = module.vm2.internal_ip_address
    vm3_ip = module.vm3.internal_ip_address
  })
}

resource "local_file" "inventory" {
  depends_on = [
    module.vm1,
    module.vm2,
    module.vm3,
    null_resource.copy_private_key_to_vm1
  ]
  content  = local.inventory_template
  filename = "${path.root}/../ansible/inventory"
}

# Provisioner для установки Ansible на vm1
resource "null_resource" "install_ansible" {
  depends_on = [
    module.vm1,
    module.vm2,
    module.vm3,
    null_resource.copy_private_key_to_vm1
  ]

  connection {
    type        = "ssh"
    host        = module.vm1.external_ip_address
    user        = "ubuntu"
    private_key = file("C:\\Users\\valar\\.ssh\\terraform_20250320")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y ansible"
    ]
  }
}

resource "null_resource" "clone_playbooks" {
  depends_on = [
    null_resource.install_ansible   # Убедитесь, что Ansible установлен
  ]

  connection {
    type        = "ssh"
    host        = module.vm1.external_ip_address
    user        = "ubuntu"
    private_key = file("C:\\Users\\valar\\.ssh\\terraform_20250320")
  }

  provisioner "remote-exec" {
  inline = [
    # Установка Git, если его нет
    "sudo apt update && sudo apt install -y git",

    # Установка Ansible, если его нет
    "if ! ansible --version >/dev/null 2>&1; then sudo apt install -y ansible; fi",

    # Создание директории для репозитория
    "mkdir -p /home/ubuntu/ansible-repo && cd /home/ubuntu/ansible-repo",

    # Инициализация Git-репозитория
    "git init",

    # Добавление удаленного репозитория
    "git remote add origin https://stds58:${var.github_token}@github.com/stds58/terraform_ansible_projectwork.git",

    # Включение sparse-checkout
    "git sparse-checkout init --cone",

    # Указание папки для загрузки (например, ansible)
    "git sparse-checkout set ansible",

    # Загрузка данных из репозитория
    "git pull origin master",

    # Копирование нужной папки в целевую директорию
    "cp -r /home/ubuntu/ansible-repo/ansible /home/ubuntu/ansible",

    # Очистка временных файлов
    "rm -rf /home/ubuntu/ansible-repo"
  ]
}
}
