variable "region" {}
variable "vpc_cidr_block" {}
variable "env" {}
variable "enable_dns_support" {
  type = bool
}
variable "enable_dns_hostnames" {
  type = bool
}
variable "instance_tenancy" {}
variable "vpc_name" {}

variable "public_cidr_block" {
  type = list(string)
}
variable "private_cidr_block" {
  type = list(string)
}
variable "pubsub_name" {}
variable "prisub_name" {}
variable "IGW_name" {}

variable "PubRT_name" {}
variable "cidr_block" {}

variable "EIP_name" {}
variable "NGW_name" {}
variable "PriRT_name" {}
