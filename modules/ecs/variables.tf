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

variable "alb_dns_name" {
  description = "Le DNS du Load Balancer"
  type        = string
}

variable "queue_url" {
  description = "Le DNS du Load Balancer"
  type        = string
}


variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "backend_image" {
  description = "ECR image for backend"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ECS service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "lb_listener" {
  description = "ALB listener reference"
  type        = any
}

variable "task_cpu" {
  description = "Task CPU units"
  type        = number
  default     = 1024
}

variable "task_memory" {
  description = "Task memory in MB"
  type        = number
  default     = 2048
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment_vars" {
  description = "Container environment variables"
  type        = list(map(string))
  default     = []
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}