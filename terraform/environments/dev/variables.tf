variable "aws_region" {
  type        = string
}

variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "owner" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "public_subnet_cidrs" {
  type        = list(string)
}

variable "private_subnet_cidrs" {
  type        = list(string)
}

variable "database_subnet_cidrs" {
  type        = list(string)
}

variable "domain_name" {
  type        = string
}

variable "task_cpu" {
  type        = string
}

variable "task_memory" {
  type        = string
}

variable "desired_count" {
  type        = number
}

variable "min_capacity" {
  type        = number
}

variable "max_capacity" {
  type        = number
}

variable "alert_email" {
  type        = string
}