variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "alb_arn_suffix" {
  type        = string
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}
