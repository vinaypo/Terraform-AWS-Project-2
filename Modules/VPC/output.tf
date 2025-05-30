output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.Public_subnet.*.id
}
output "private_subnet_ids" {
  value = aws_subnet.Private_subnet.*.id
}
