variable "network_id" {
  description = "ID of the VPC network."
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group."
  type = list(object({
    protocol       = string
    port           = number
    v4_cidr_blocks = list(string)
  }))
  default = []
}

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