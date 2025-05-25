# 1. Elastic IPs for NAT 
resource "aws_eip" "nat_eip" {
  count = length(var.availability_zone_public)
  domain = "vpc"
  tags = {
    Name = "NAT EIP ${count.index}"
  }
}

# 2. VPC 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "iovison-vpc"
  }
}

# 3. Internet Gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "iovison-igw"
  }
}

# public subnet
resource "aws_subnet" "public" {
  count = length(var.availability_zone_public)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = var.availability_zone_public[count.index]
  
  tags = {
    Name = "iovison-public-subnet-${var.availability_zone_public[count.index]}"
  }
}
#5. private subnet
resource "aws_subnet" "private" {
  count = length(var.availability_zone_private)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 101}.0/24"
  availability_zone = var.availability_zone_private[count.index]
  
  tags = {
    Name = "iovison-private-subnet-${var.availability_zone_private[count.index]}"
  }
}
# 6. NAT Gateways (un par AZ)
resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zone_public)
  
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "iovison-nat-gateway-${var.availability_zone_public[count.index]}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# 7. Route Table for public subnets (inchangé)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "iovison-public-route-table"
  }
}

# 8. Associate Route Table with Public Subnets (mis à jour pour gérer plusieurs sous-réseaux)
resource "aws_route_table_association" "public_assoc" {
  count = length(var.availability_zone_public)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# 9. Route Tables for private subnets (une par AZ)
resource "aws_route_table" "private_rt" {
  count = length(var.availability_zone_public)
  
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "iovison-private-route-table-${var.availability_zone_public[count.index]}"
  }
}

# 10. Associate Route Tables with Private Subnets (mis à jour)
resource "aws_route_table_association" "private_assoc" {
  count = length(var.availability_zone_public)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow database traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
}