# Intro to Cloud Automation with Terraform
# Instructions:  Base Configuration

## GUI Walk-Through
AWS Console URL:  https://console.aws.amazon.com  

Click: EC2 -> Instances -> Launch Instance

1. Name: terraform_gui
2. Choose Operating System: Amazon Linux
3. Instance Type: t2.micro
4. Create New Key Pair:  terraform
5. Create Security Group:  terraform
6. Allow SSH from "My IP"
7. Configure Storage: 30gb
8. Launch Instance


## Terraform Walk-Through
### Git Clone Command

```
git clone https://github.com/towerindustries/saintcon23.git
```

## Base Configuration

Rename the following "example" to your desired name:
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

Once your have chosen your friendly names, update the associated references in the main.tf file.  
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
Modify the security group with your current IP.

```
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your current ip
  }
    ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your current ip
  }
    ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your current ip
  }
```

# Terraform Commands
```
terraform init
terraform fmt
terraform plan
terraform apply
```