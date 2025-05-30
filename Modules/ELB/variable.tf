variable "alb_name" {}
variable "alb_sec_id" {
  description = "Security group ID for the ALB"
}
variable "env" {}
variable "public_subnet_ids" {}
variable "targettype" {}
variable "vpc-id" {
  description = "VPC ID where the ALB and target group will be created"

}
variable "tgname" {
  description = "Name for the target group"
}
variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
}
