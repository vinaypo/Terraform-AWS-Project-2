resource "aws_instance" "Private_Server" {
  ami                         = lookup(var.ami, var.region)
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.Private_Server_sec_id]
  associate_public_ip_address = false
  subnet_id                   = var.private_subnet_id
  tags = {
    Name = var.pri_instance_name
    Env  = var.env
  }
  lifecycle {
    create_before_destroy = true
  }
}
