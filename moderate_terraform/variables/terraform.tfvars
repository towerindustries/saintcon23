######################
## Provider Details ##
######################
availability_zone = "us-east-1a"

#####################
## Security Groups ##
#####################
sg_cidr_blocks_allow_ssh = ["104.28.252.4/32"]
sg_cidr_blocks_allow_http = ["104.28.252.4/32"]
sg_cidr_blocks_allow_https = ["104.28.252.4/32"]

##################
## EC2 Instance ##
##################
instance_type = "t2.micro"
key_name = "dev-example-key"
volume_size = "30"
volume_type = "gp3"
