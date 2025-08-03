variable "aws_region" {
  description = "AWS region for the backend resources"
  type        = string
  default     = "eu-west-2"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "475641479654"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "gatus-ecs"
}