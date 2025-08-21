variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}