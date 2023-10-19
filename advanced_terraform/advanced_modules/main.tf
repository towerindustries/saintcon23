

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  azs = "us-east-1a,us-east-1b,us-east-1c"
  cidr = "10.0.0.0/16"
  create_igw = true
  create_vpc = true
}
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
}
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest/examples/complete
module "ec2-instance_example_complete" {
  source  = "terraform-aws-modules/ec2-instance/aws//examples/complete"
  version = "5.5.0"
}