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

module "Private-Ec2" {
  source                = "../Modules/Private-Instance"
  ami                   = var.ami
  env                   = var.env
  region                = var.region
  instance_type         = var.instance_type
  Private_Server_sec_id = module.SecurityGroup.Pri_Server_sec_id
  private_subnet_id     = module.vpc.private_subnet_ids[0]
  pri_instance_name     = "${local.env}-${var.pri_instance_name}"
  key_name              = var.key_name
  src1                  = var.src1
  destination1          = var.destination1
  private_key           = var.private_key
  user                  = var.user
  connection_type       = var.connection_type
  commands1             = var.commands1
  Jump_Server_public_ip = module.Ec2.Jump_Server_public_ip
  depends_on            = [module.SecurityGroup]
}


