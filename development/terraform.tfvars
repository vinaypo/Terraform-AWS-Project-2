region               = "us-east-1"
vpc_cidr_block       = "192.168.0.0/16"
env                  = "dev" # dev, prod, testing
enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"
vpc_name             = "vpc-terraform"
public_cidr_block    = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
private_cidr_block   = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
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
private_key             = "path/.pem" # Path to your private key file
user                    = "ubuntu"
connection_type         = "ssh"
destination             = "/home/ubuntu/.pem"
src1                    = "path/.sh"
destination1            = "/home/ubuntu/.sh"
commands                = ["chmod 400 /home/ubuntu/.pem"]
commands1               = ["chmod +x /home/ubuntu/.sh", "sudo bash /home/ubuntu/.sh"]
security_group_name     = "JumperServer-SG"
pri_security_group_name = "PrivateServer-SG"
ingress_value           = ["80", "22"]
ingress2_value          = ["80", "22", "443"]
pri_instance_name       = "Private-Server"

# Path to your user data script file


