# Intro to Terraform

## Git Clone Command

```git clone git@github.com:towerindustries/saintcon23.git```


## Base Configuration

Rename the following to your desired name:
```
resource "aws_vpc" "example"
resource "aws_internet_gateway" "example"
resource "aws_subnet" "example"
resource "aws_route_table" "example"
resource "aws_route" "default_route"
resource "aws_route_table_association" "example"
resource "aws_security_group" "example"
resource "aws_instance" "example"

value = aws_instance.example.public_ip
```

Once done update the associated references in the main.tf file.  
Each line below represents a reference that needs to be updated.
```
vpc_id          = aws_vpc.example.id
vpc_id          = aws_vpc.example.id
vpc_id          = aws_vpc.example.id
route_table_id  = aws_route_table.example.id
gateway_id      = aws_internet_gateway.example.id
subnet_id       = aws_subnet.example.id
route_table_id  = aws_route_table.example.id
vpc_id          = aws_vpc.example.id
subnet_id       = aws_subnet.example.id 
aws_security_group.example.id

value = aws_instance.example.public_ip
```

# Launch Terraform
```
terraform init
terraform fmt
terraform plan
terraform apply
```