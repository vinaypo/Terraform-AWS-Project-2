resource "aws_instance" "Jump_Server" {
  ami                         = lookup(var.ami, var.region)
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.Jump_Server_sec_id]
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id
  tags = {
    Name = var.instance_name
    Env  = var.env
  }
  lifecycle {
    create_before_destroy = true
  }
}
