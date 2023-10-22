# /saintcon23/advanced_terraform/intro_to_modules/main.tf
module "ami_amazon2023" {
  source = "./modules/ami_amazon2023/"
  #  version = "1.0.0"
}

module "networking" {
  source = "./modules/networking/"
  #  version = "1.0.0"
  vpc_cidr_block    = "10.255.0.0/16"
  subnet_cidr_block = "10.255.1.0/24"
  network_tags      = local.network_tags
  vpc_tags          = local.vpc_tags
}
module "security_groups" {
  source = "./modules/security_groups/"
  #  version = "1.0.0"
  vpc_id                     = module.networking.vpc_id
  sg_cidr_blocks_allow_http  = ["161.28.24.210/32"]
  sg_cidr_blocks_allow_https = ["161.28.24.210/32"]
  sg_cidr_blocks_allow_ssh   = ["161.28.24.210/32"]
  security_tags              = local.security_tags
}
module "ec2" {
  source = "./modules/ec2/"
  #  version = "1.0.0"
  instance_type          = "t2.micro"
  ami                    = module.ami_amazon2023.latest_amazon_linux_2023_ami_id
  key_name               = "dev-example-key"
  volume_size            = "30"
  volume_type            = "gp3"
  ec2_tags               = local.ec2_tags
  subnet_id              = module.networking.subnet_id
  security_group_id      = [module.security_groups.security_group_id]
}
