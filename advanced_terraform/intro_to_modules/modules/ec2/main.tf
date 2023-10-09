# saintcon23/advanced_terraform/intro_to_modules/modules/ec2/main.tf
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux_2023.id 
  instance_type = var.instance_type             
  key_name      = var.key_name   
  subnet_id     = aws_subnet.example.id   
  tags = local.common_tags

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = file("nginxserver_amazon_deploy.sh")
}