
variable "zone" {                                # Используем переменную для передачи в конфиг инфраструктуры
  description = "Use specific availability zone" # Опционально описание переменной
  type        = string                           # Опционально тип переменной
  default     = "ru-central1-a"
}

variable "subnet_name" {
  description = "Имя подсети"
  type        = string
}

variable "v4_cidr_blocks" {
  description = "CIDR блоки для подсети"
  type        = list(string)
}

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "folder_id" {
  description = "ID каталога в Yandex Cloud"
  type        = string
}

variable "cloud_id" {
  type = string
}

variable "token" {
  type = string
}