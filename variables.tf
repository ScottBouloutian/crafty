variable "aws_access_key_id" {
  type        = string
  description = "aws access key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "aws secret access key"
}

variable "aws_default_region" {
  type        = string
  description = "aws default region"
  default     = "us-east-1"
}
