resource "aws_security_group" "Jump_Server_sec" {
  vpc_id      = var.vpc_id
  name        = var.security_group_name
  description = "Security group for Jump Server"

  dynamic "ingress" {
    for_each = var.ingress_value
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
  tags = {
    Name = var.security_group_name
    Env  = var.env
  }
}

resource "aws_security_group" "Pri_Server_sec" {
  vpc_id      = var.vpc_id
  name        = var.pri_security_group_name
  description = "Security group for Private Server"

  dynamic "ingress" {
    for_each = var.ingress2_value

    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.Jump_Server_sec.id]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
  tags = {
    Name = var.pri_security_group_name
    Env  = var.env
  }
  depends_on = [aws_security_group.Jump_Server_sec]
}
