locals {
  env = var.env
}
module "vpc" {
  source               = "../Modules/VPC"
  region               = var.region
  vpc_cidr_block       = var.vpc_cidr_block
  env                  = var.env
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  vpc_name             = "${local.env}-${var.vpc_name}"
  public_cidr_block    = var.public_cidr_block
  private_cidr_block   = var.private_cidr_block
  pubsub_name          = "${local.env}-${var.pubsub_name}"
  prisub_name          = "${local.env}-${var.prisub_name}"
  IGW_name             = "${local.env}-${var.IGW_name}"
  PubRT_name           = "${local.env}-${var.PubRT_name}"
  cidr_block           = var.cidr_block
  EIP_name             = "${local.env}-${var.EIP_name}"
  NGW_name             = "${local.env}-${var.NGW_name}"
  PriRT_name           = "${local.env}-${var.PriRT_name}"

}

module "SecurityGroup" {
  source                  = "../Modules/SecurityGroup"
  security_group_name     = "${local.env}-${var.security_group_name}"
  env                     = var.env
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.cidr_block
  ingress_value           = var.ingress_value
  ingress2_value          = var.ingress2_value
  depends_on              = [module.vpc]
  pri_security_group_name = "${local.env}-${var.pri_security_group_name}"
}

module "Ec2" {
  source             = "../Modules/EC2-Instance"
  ami                = var.ami
  env                = var.env
  region             = var.region
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  Jump_Server_sec_id = module.SecurityGroup.Jump_Server_sec_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  instance_name      = "${local.env}-${var.instance_name}"
  private_key        = var.private_key
  user               = var.user
  connection_type    = var.connection_type
  src                = var.private_key
  destination        = var.destination
  commands           = var.commands
  depends_on         = [module.SecurityGroup]
}

module "ELB" {
  source            = "../Modules/ELB"
  alb_name          = "${local.env}-${var.alb_name}"
  alb_sec_id        = module.SecurityGroup.Jump_Server_sec_id
  env               = var.env
  public_subnet_ids = module.vpc.public_subnet_ids
  targettype        = var.targettype
  vpc-id            = module.vpc.vpc_id
  tgname            = "${local.env}-${var.tgname}"
  certificate_arn   = var.certificate_arn
}

module "ASG" {
  source               = "../Modules/Auto-Scaling"
  launch_template_name = "${local.env}-${var.launch_template_name}"
  asgname              = "${local.env}-${var.asgname}"
  desired_capacity     = var.desired_capacity
  region               = var.region
  ami_id               = var.ami
  key_name             = var.key_name
  max_size             = var.max_size
  min_size             = var.min_size
  env                  = var.env
  private_subnet_ids   = module.vpc.private_subnet_ids
  target_group_arn     = module.ELB.target_group_arn
  as_group_id          = module.SecurityGroup.Pri_Server_sec_id
  instance_type        = var.instance_type
  file                 = var.file
}
