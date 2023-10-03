###############################################
## Print the Public IP to the Console Screen ##
###############################################
output "public_ip" {
  value = aws_instance.example.public_ip # This will print on the screen what Public IP we need to ssh to.
}
output "vpc_id" {
  value = aws_vpc.example.id
}
output "subnet_id" {
  value = aws_subnet.example.id
}
output "route_table_id" {
  value = aws_route_table.example.id
}
output "security_group_id" {
  value = aws_security_group.example.id
}
output "instance_id" {
  value = aws_instance.example.id
}
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
output "instance_private_ip" {
  value = aws_instance.example.private_ip
}
output "instance_availability_zone" {
  value = aws_instance.example.availability_zone
}
output "instance_ami" {
  value = aws_instance.example.ami
}
output "instance_type" {
  value = aws_instance.example.instance_type
}
output "instance_key_name" {
  value = aws_instance.example.key_name
}
output "instance_security_groups" {
  value = aws_instance.example.security_groups
}
output "instance_vpc_security_group_ids" {
  value = aws_instance.example.vpc_security_group_ids
}
output "instance_subnet_id" {
  value = aws_instance.example.subnet_id
}
output "instance_public_dns" {
  value = aws_instance.example.public_dns
}
output "instance_private_dns" {
  value = aws_instance.example.private_dns
}
output "instance_ebs_block_device" {
  value = aws_instance.example.ebs_block_device
}
output "instance_root_block_device" {
  value = aws_instance.example.root_block_device
}
output "instance_associate_public_ip_address" {
  value = aws_instance.example.associate_public_ip_address
}
