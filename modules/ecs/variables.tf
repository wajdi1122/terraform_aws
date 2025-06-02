variable "vpc_id" {
  description = "L id du reseau"
  type = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "frontend_target_group_arn" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "db_host" {
  type = string
}

variable "container_image" {
  type = string
}

