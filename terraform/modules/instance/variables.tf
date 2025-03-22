
variable "zone" {
  description = "Use specific availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "name" {
  description = "Имя_инстанса"
  type        = string
}

variable "platform_id" {
  description = "Тип платформы (например, standard-v2)"
  type        = string
}

variable "cores" {
  description = "Количество vCPU # Определяет количество vCPU"
  type        = number
}

variable "memory" {
  description = "Объем RAM в ГБ # Определяет объем RAM в гигабайтах"
  type        = number
}

variable "core_fraction" {
  description = "Гарантированная доля CPU в процентах # Определяет гарантированную долю CPU в процентах"
  type        = number
}

variable "image_id" {
  description = "ID образа для загрузочного диска"
  type        = string
}

variable "disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
}

variable "disk_type" {
  description = <<-EOT
    Type of the boot disk. Тип загрузочного диска
    Network SSD (network-ssd): Fast network drive; SSD network block storage.
    Network HDD (network-hdd): Standard network drive; HDD network block storage.
    Non-replicated SSD (network-ssd-nonreplicated): Enhanced performance network drive without redundancy.
    Ultra high-speed network storage with three replicas (SSD) (network-ssd-io-m3): High-performance SSD offering the same speed as network-ssd-nonreplicated, plus redundancy.
    Local disk drives on dedicated hosts.
  EOT
  type        = string
}

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "ssh_key_path" {
  description = "Путь к SSH-ключу"
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

variable "metadata" {
  description = "Metadata to pass to the instance."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "security_group_ids" {
  description = "List of security group IDs to assign to the instance."
  type        = list(string)
  default     = []
}