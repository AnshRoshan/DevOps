# Example main.tf
# vpc then sg then ec2 instance

# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.azs.names
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets = var.public_subnets
  # enable_nat_gateway = true
  # enable_vpn_gateway = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true
  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"

  }
}

# security group for jenkins
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Jenkins-SG"
  description = "Security group for Jenkins-SG server"
  vpc_id      = module.vpc.vpc_id

  # ingress_cidr_blocks      = ["10.10.0.0/16"]
  # ingress_rules            = ["https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins-SG HTML ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },

  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = {
    Name        = "Jenkins-SG"
    Environment = "dev"
  }
}

# creating the ec2 instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.amzn2_latest.id # "ami-0c55b159cbfafe1f0"
  name   = "Jenkins-Server"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}

# resource "aws_instance" "example" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t2.micro"
# }
