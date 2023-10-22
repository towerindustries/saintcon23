# saintcon23/advanced_terraform/intro_to_modules/modules/networking/outputs.tf
output "vpc_id" {
  value = aws_vpc.example.id
}
output "subnet_id" {
  value = aws_subnet.example.id
}