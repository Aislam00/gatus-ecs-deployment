variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "ecs_security_group_id" {
  type        = string
}

variable "ecr_repository_url" {
  type        = string
}

variable "target_group_arn" {
  type        = string
  default     = ""
}

variable "task_cpu" {
  type        = string
  default     = "256"
}

variable "task_memory" {
  type        = string
  default     = "512"
}

variable "desired_count" {
  type        = number
  default     = 1
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}
