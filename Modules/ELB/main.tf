resource "aws_lb" "pro-alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sec_id]
  subnets            = var.public_subnet_ids


  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
    Env  = var.env
  }
}

resource "aws_lb_target_group" "lbtg" {
  name        = var.tgname
  target_type = var.targettype
  protocol    = "HTTP"
  port        = "80"
  vpc_id      = var.vpc-id

  health_check {
    path = "/"
    port = "80"
  }
  tags = {
    Name = var.tgname
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.pro-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbtg.arn
  }

}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.pro-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.lbtg.arn

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
