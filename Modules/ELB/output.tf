output "alb-arn" {
  value = aws_lb.pro-alb.arn
}
output "alb-dns-name" {
  value = aws_lb.pro-alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.lbtg.arn

}
