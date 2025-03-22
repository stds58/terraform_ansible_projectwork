
variable "name" {
  description = "Имя подсети"
  type        = string
}

variable "zone" {                                # Используем переменную для передачи в конфиг инфраструктуры
  description = "Use specific availability zone" # Опционально описание переменной
  type        = string                           # Опционально тип переменной
  default     = "ru-central1-a"
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