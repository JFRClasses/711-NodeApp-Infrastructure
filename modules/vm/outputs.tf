output "aws_instance_ip" {
  value = aws_instance.restaurant_app_instance.public_ip
}