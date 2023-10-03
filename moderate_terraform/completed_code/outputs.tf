output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}