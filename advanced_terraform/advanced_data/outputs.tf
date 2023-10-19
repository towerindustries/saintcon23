output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}

output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}
output "current_vpc_id" {
  value = data.aws_vpc.current_vpc.id
}