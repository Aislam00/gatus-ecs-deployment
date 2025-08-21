variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "database_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.40.0/24"]
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}