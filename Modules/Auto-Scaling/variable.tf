variable "env" {}
variable "launch_template_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "as_group_id" {}
variable "asgname" {

}
variable "desired_capacity" {
  type = number
}
variable "region" {

}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "target_group_arn" {
  description = "ARN of the target group for the Auto Scaling group"
  type        = string
}
variable "file" {

}
