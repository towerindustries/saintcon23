# saintcon23/advanced_terraform/intro_to_modules/modules/security_groups/outputs.tf
output "security_group_id" {
  value = aws_security_group.example.id
}