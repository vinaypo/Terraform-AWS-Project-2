resource "null_resource" "null_jps" {
  connection {
    type        = var.connection_type
    user        = var.user
    private_key = file(var.private_key)
    host        = aws_instance.Jump_Server.public_ip
  }
  provisioner "file" {
    source      = var.src
    destination = var.destination
  }
  provisioner "remote-exec" {
    inline = var.commands
  }
  depends_on = [aws_instance.Jump_Server]
  lifecycle {
    create_before_destroy = true
  }
}
