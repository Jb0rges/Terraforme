# =========================
# VPC
# =========================

resource "aws_vpc" "main" {

  # Faixa de IP da rede
  cidr_block = "10.0.0.0/16"

  # Habilita DNS interno
  enable_dns_support = true

  # Habilita hostnames DNS
  enable_dns_hostnames = true

  tags = {
    Name = "prod-vpc"
  }
}

# =========================
# INTERNET GATEWAY
# =========================

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "prod-igw"
  }
}

# =========================
# SUBNET A
# =========================

resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-a"
  }
}

# =========================
# SUBNET B
# =========================

resource "aws_subnet" "public_b" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-b"
  }
}

# =========================
# ROUTE TABLE
# =========================

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    # Rota para internet
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associação da subnet A

resource "aws_route_table_association" "public_a" {

  subnet_id = aws_subnet.public_a.id

  route_table_id = aws_route_table.public.id
}

# Associação da subnet B

resource "aws_route_table_association" "public_b" {

  subnet_id = aws_subnet.public_b.id

  route_table_id = aws_route_table.public.id
}