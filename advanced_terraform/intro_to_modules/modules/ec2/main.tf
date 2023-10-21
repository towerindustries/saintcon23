# saintcon23/advanced_terraform/intro_to_modules/modules/ec2/main.tf
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  tags          = var.ec2_tags

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = var.security_group_id
  user_data = file("nginxserver_amazon_deploy.sh")
}
