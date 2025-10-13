variable "aws_secret_key" {
  type = string
  default = ""
}

variable "aws_access_key" {
  type = string
  default = ""
}

variable "node_app_service" {
  type = string
}
variable "node_app_email" {
  type = string
}
variable "node_app_password" {
  type = string
}

variable "node_app_image" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_server_name" {
  type = string
}
variable "aws_env" {
  type = string
}

variable "aws_key_pair_name" {
  type = string
}

variable "aws_sg_name" {
  type = string
}

variable "main_domain"{
  type = string
}