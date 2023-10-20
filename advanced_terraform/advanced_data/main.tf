resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = var.availability_zone
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}