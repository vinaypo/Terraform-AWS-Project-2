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
variable "ami" {
  type = map(string)
}
variable "instance_type" {}
variable "key_name" {}
variable "instance_name" {}
variable "private_key" {}
variable "user" {}
variable "connection_type" {}
variable "destination" {}
variable "commands" {}
variable "security_group_name" {}
variable "pri_security_group_name" {}
variable "ingress_value" {}
variable "ingress2_value" {}
variable "alb_name" {}
variable "targettype" {}
variable "tgname" {
  description = "Name for the target group"
}
variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
}

variable "launch_template_name" {}
variable "asgname" {
}
variable "desired_capacity" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "file" {

}





