region               = "us-east-1"
vpc_cidr_block       = "10.0.0.0/16"
env                  = "prod" # dev, prod, testing
enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"
vpc_name             = "vpc-terraform"
public_cidr_block    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidr_block   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
pubsub_name          = "public-subnet"
prisub_name          = "private-subnet"
IGW_name             = "Internet-Gateway"
PubRT_name           = "Public-Rt"
cidr_block           = "0.0.0.0/0"
EIP_name             = "Elastic-IP"
NGW_name             = "NAT-Gateway"
PriRT_name           = "Private-Rt"
instance_type        = "t2.micro"
key_name             = "demo" # the .pem file should be in the same region as the instance
instance_name        = "Jump-Server"
ami = {
"us-east-1" = "ami-084568db4383264d4" }
private_key             = "path /.pem" # Path to your private key file
user                    = "ubuntu"
connection_type         = "ssh"
destination             = "/home/ubuntu/.pem"
commands                = ["chmod 400 /home/ubuntu/.pem"]
security_group_name     = "JumperServer-SG"
pri_security_group_name = "PrivateServer-SG"
ingress_value           = ["80", "22", "443"]
ingress2_value          = ["80", "22"]
alb_name                = "pro-alb"
targettype              = "instance"
tgname                  = "pro-tg"
certificate_arn         = "certificate_arn"
launch_template_name    = "terraform-lt"
asgname                 = "terraform-asg"
desired_capacity        = 1
max_size                = 4
min_size                = 1
file                    = "path /.sh" # Path to your user data script file



