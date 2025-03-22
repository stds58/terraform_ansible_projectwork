locals {
  inventory_template = templatefile("${path.module}/inventory.tpl", {
    vm1_ip = module.vm1.internal_ip_address
    vm2_ip = module.vm2.internal_ip_address
    vm3_ip = module.vm3.internal_ip_address
  })
}

resource "local_file" "inventory" {
  content  = local.inventory_template
  filename = "${path.root}/../ansible/inventory"
}

# Provisioner для установки Ansible на vm1
resource "null_resource" "install_ansible" {
  depends_on = [module.vm1]

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
  depends_on = [module.vm1]

  connection {
    type        = "ssh"
    host        = module.vm1.external_ip_address
    user        = "ubuntu"
    private_key = file("C:\\Users\\valar\\.ssh\\terraform_20250320")
  }

  provisioner "remote-exec" {
  inline = [
    "sudo apt install -y git", # Установка Git, если его нет
    "if ! ansible --version >/dev/null 2>&1; then sudo apt install -y ansible; fi", # Установка Ansible, если его нет
    "echo 'Cloning repository from GitHub...'",
    "if git clone https://stds58:${var.github_token}@github.com/stds58/ansible_projectwork.git /home/ubuntu/ansible; then echo 'Repository cloned successfully'; else echo 'Failed to clone repository'; fi"
  ]
}
}

resource "null_resource" "run_playbook" {
  depends_on = [null_resource.clone_playbooks]

  connection {
    type        = "ssh"
    host        = module.vm1.internal_ip_address
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/ansible-playbooks",
      "ansible-playbook -i inventory.ini playbook.yml"
    ]
  }
}