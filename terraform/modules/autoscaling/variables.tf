variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "cluster_name" {
  type        = string
}

variable "service_name" {
  type        = string
}

variable "min_capacity" {
  type        = number
  default     = 1
}

variable "max_capacity" {
  type        = number
  default     = 4
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}
