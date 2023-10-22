# saintcon23/advanced_terraform/intro_to_modules/modules/ec2/outputs.tf
#################
## EC2 Outputs ##
#################
output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}
