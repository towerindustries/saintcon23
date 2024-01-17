# Intro to Cloud Automation with Terraform
# Instructions:  Base Configuration

## 1: GUI Walk-Through
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


## 2: Terraform Walk-Through
### Git Clone Command - if not already done.

```
git clone https://github.com/towerindustries/saintcon23.git
```

## 3: Base Configuration

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

# 4: Terraform Commands
```
terraform init
terraform fmt
terraform plan
terraform apply
```
# Next Step 
```/saintcon23/moderate_terraform/README.md```

# Appendix A: The Completed Code -- Spoiler Alert
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
############################################
## Create the VPC (Virtual Private Cloud) ##
############################################
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}
#################################
## Create the Internet Gateway ##
#################################
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}
#######################
## Create the Subnet ##
#######################
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dev-subnet"
  }
}
############################
## Create the Route Table ##
############################
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-route-table"
  }
}
##############################
## Create the Default Route ##
##############################
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.example.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}
##################################
## Create the Route Association ##
##################################
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}
#############################################
## Create the Security Group to allow SSH  ##
## Modify the cider_blocks to your home IP ##
#############################################
resource "aws_security_group" "example" {
  name_prefix = "dev-ssh-access"
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
    ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
    ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["66.0.0.97/32"] # Change this to your home ip
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] ## Allow all outbound traffic
  }
  tags = {
    Name = "dev-security-group"
  }
  
  vpc_id = aws_vpc.example.id
}

####################################
## Create the actual Ec2 Instance ##
####################################
resource "aws_instance" "example" {
  ami           = "ami-03a6eaae9938c858c" # Feed it the AMI you found
  instance_type = "t2.micro"                # Choose the size/type of compute you want
  key_name      = "dev-example-key"           # Here is the public key you want for ssh.
  subnet_id     = aws_subnet.example.id       # Put it on the Subnet you created.
  tags = {
    Name = "dev-amazon2023"
  }  
  
  root_block_device {
    volume_size = 30    # If you wanted to increase the hard drive space here it is.
    volume_type = "gp3" # The type of storage you want to use.
    encrypted   = true
  }
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.example.id # Add the security group you created.
  ]
  user_data = <<EOF
#!/bin/bash
sudo dnf --assumeyes update
sudo dnf --assumeyes upgrade
sudo dnf install -y epel-release

### Install Firewalld ###
sudo dnf --assumeyes install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --permanent --add-service=ssh
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo systemctl reload firewalld

### Install Nginx ###
sudo dnf module enable nginx:mainline
sudo dnf --assumeyes install nginx
sudo systemctl enable --now nginx

### Configure Nginx ###
sudo mv /usr/share/nginx/html/index.html index.html.bak
sudo touch /usr/share/nginx/html/index.html
sudo chown -R  nginx:nginx /usr/share/nginx/
sudo mkdir /etc/pki/nginx/
sudo chown -R  nginx:nginx /usr/share/nginx/
sudo cat > /usr/share/nginx/html/index.html << EOF1
<html>
    <head>
        <title>Welcome to Intro to Terraform!</title>
    </head>
    <body><font size="20"> 
        <p>Welcome to Intro to Terraform!</b>!</p>
        </font> 
    </body>
</html>
EOF1

#######################
### Configure Nginx ###
#######################
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo cat > /etc/nginx/nginx.conf << EOF2
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
   server {
       listen       443 ssl http2;
       listen       [::]:443 ssl http2;
       server_name  terraform.energy.gov;
       root         /usr/share/nginx/html;

       ssl_certificate "/etc/pki/nginx/server.crt";
       ssl_certificate_key "/etc/pki/nginx/private/server.key";
       ssl_session_cache shared:SSL:1m;
       ssl_session_timeout  10m;
       ssl_protocols TLSv1.3;
       ssl_ciphers HIGH;
       ssl_prefer_server_ciphers on;

       # Load configuration files for the default server block.
       include /etc/nginx/default.d/*.conf;

       error_page 404 /404.html;
           location = /40x.html {
       }

       error_page 500 502 503 504 /50x.html;
           location = /50x.html {
       }
   }

}
EOF2

sudo cat > ~/server_rootCA.csr.cnf << EOF3
# server_rootCA.csr.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=US
ST=Virginia
L=Germantown
O=doe
OU=local_RootCA
emailAddress=ikke@server.germantown
CN = terraform.saintcon.org
EOF3

sudo mkdir /etc/pki/nginx/private/
sudo openssl req -new -sha256 -nodes -out /etc/pki/nginx/server.csr -newkey rsa:2048 -keyout /etc/pki/nginx/private/server.key -config ~/server_rootCA.csr.cnf  
sudo openssl x509 -signkey /etc/pki/nginx/private/server.key -in /etc/pki/nginx/server.csr -req -days 365 -out /etc/pki/nginx/server.crt
sudo chown -R  nginx:nginx /usr/share/nginx/
sudo chown -R  nginx:nginx /etc/pki/nginx/
sudo systemctl restart nginx
EOF
}
output "ec2_global_ips" {
  value = aws_instance.example.public_ip
}
```
