# /saintcon23/advanced_terraform/intro_to_modules/main.tf
module "security_group" {
  source = "./modules/security_groups/"
  #  version = "1.0.0"
}
module "ec2_instance" {
  source = "./modules/ec2/"
  #  version = "1.0.0"
}
module "ami_selection" {
  source = "./modules/ami/"
  #  version = "1.0.0"
}