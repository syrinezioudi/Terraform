variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_ssh_key" {
  type = string
}

variable "public_ip" {
  type = bool
}

variable "network_subnet_id" {
  type = string
}