resource "null_resource" "private_null_jps" {
  connection {
    type        = var.connection_type
    user        = var.user
    private_key = file(var.private_key)
    host        = aws_instance.Private_Server.private_ip

    bastion_host        = var.Jump_Server_public_ip
    bastion_user        = var.user
    bastion_private_key = file(var.private_key)

  }
  provisioner "file" {
    source      = var.src1
    destination = var.destination1
  }
  provisioner "remote-exec" {
    inline = var.commands1
  }
  depends_on = [aws_instance.Private_Server]
  lifecycle {
    create_before_destroy = true
  }
}
