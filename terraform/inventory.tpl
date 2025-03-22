[app]
vm2 ansible_host=${vm2_ip} ansible_user=ubuntu
vm3 ansible_host=${vm3_ip} ansible_user=cloud-user

[database]
vm1 ansible_host=${vm1_ip} ansible_user=ubuntu

[web]
vm1 ansible_host=${vm1_ip} ansible_user=ubuntu

[all:vars]
ansible_ssh_private_key_file=~/.ssh/terraform_20250320
