variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "database_name" {
  type    = string
  default = "hr_platform"
}

variable "database_username" {
  type    = string
  default = "postgres"
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "multi_az" {
  type    = bool
  default = false
}
