
variable "zone" {
  description = "Use specific availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "folder_id" {
  description = "ID каталога в Yandex Cloud"
  type        = string
  default     = ""
}

variable "cloud_id" {
  type    = string
  default = ""
}

variable "token" {
  type    = string
  default = ""
}

variable "ssh_key_path" {
  description = "ssh-rsa AAAAB3NzaC1yc2E... user@host Ваш локальный ключ для доступа к vm"
  type        = string
  default     = "C:\\Users\\valar\\.ssh\\terraform_20250320.pub"
}

variable "github_token" {
  description = "github_token"
  type        = string
  default     = "github_pat_bmjklikljjh"
}




