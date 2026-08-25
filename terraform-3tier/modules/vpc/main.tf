resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Terraform-VPC"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------
# Public Subnet A
# ---------------------------------------------------------

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Terraform-Public-Subnet-A"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------
# Public Subnet B
# ---------------------------------------------------------

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Terraform-Public-Subnet-B"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------
# Private Subnet A
# ---------------------------------------------------------

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Terraform-Private-Subnet-A"
    Tier = "Private"
  }
}

# ---------------------------------------------------------
# Private Subnet B
# ---------------------------------------------------------

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "Terraform-Private-Subnet-B"
    Tier = "Private"
  }
}

# ---------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Terraform-IGW"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------
# Public Route Table
# ---------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "Terraform-Public-RT"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------
# Public Route Associations
# ---------------------------------------------------------

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}