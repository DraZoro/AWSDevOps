resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "cka-training"
    Project = "Training"
  }
}

# Subnets 
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "af-south-1a"

  tags = {
    Name = "PublicA"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
   availability_zone = "af-south-1a"


  tags = {
    Name = "PrivateB"
  }
}

# Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "Private"
  }
}


# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.pulic.id
#   route_table_id = aws_route_table.main.id
# }

# resource "aws_route_table_association" "private" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.main.id
# }
