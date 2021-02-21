# Vault Networks

# Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  provider             = aws.region_master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vault-master-vpc"
  }
}

# Create a Internet Gateway in us-east-1 
resource "aws_internet_gateway" "igw-vault" {
  provider = aws.region_master
  vpc_id   = aws_vpc.vpc_master.id
}


# Gather all availability zones in region_master 
data "aws_availability_zones" "azs" {
  provider = aws.region_master
  state    = "available"
}

resource "aws_subnet" "vault_subnet1" {
  provider          = aws.region_master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "vault_subnet2" {
  provider          = aws.region_master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.2.0/24"
}

# Create route table in us-east-1 
resource "aws_route_table" "internet_route" {
  provider = aws.region_master
  vpc_id   = aws_vpc.vpc_master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vault.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "master-region-RT"
  }
}

# Overwrite default route table of VPC (master) to point to our route table (above)
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region_master
  vpc_id         = aws_vpc.vpc_master.id
  route_table_id = aws_route_table.internet_route.id
}
