# Variables pour le module VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}


variable "availability_zone_private" {
  description = "AWS Availability Zone"
  type        = string
  default     = "eu-north-1a"
}

variable "availability_zone" {
  description = "List of availability zones for public subnets"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"] 
}
# Variables pour le module ECS
variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "nginx:latest"
}

# Variables pour le module RDS
variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
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
