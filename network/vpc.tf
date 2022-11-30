resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "cka-training"
    Project = "Training"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH Connection"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH Public Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Subnets 
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "af-south-1a"

  tags = {
    Name = "PublicA"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "af-south-1a"


  tags = {
    Name = "PrivateA"
  }
}


resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "af-south-1b"


  tags = {
    Name = "PrivateB"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }


  tags = {
    Name = "Private"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# To be moved to its own file
resource "aws_key_pair" "dev-key" {
  key_name   = "dev-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFfifgVhD9lVBmw7FTe6IaxRoHsqHKMTMTF4u9w2R0E clement.mahlangu@gmail.com"

  tags = {
    Name    = "dev-key"
    Project = "Training"
  }

}

resource "aws_instance" "bastion" {
  # Amazon Linux 2 
  # Todo: User filter 
  ami           = "ami-0f4500c7ee9bc5381"
  instance_type = "t3.nano"
  key_name      = aws_key_pair.dev-key.id
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  # volume_type = "gp3"

  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "worker-1" {
  # Amazon Linux 2 
  # Todo: User filter 
  # Ubuntu 20.04
  ami           = "ami-0fffe3a460634f60c"
  instance_type = "t3.nano"
  key_name      = aws_key_pair.dev-key.id
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  # volume_type = "gp3"

  tags = {
    Name = "Worker-1"
  }

}

resource "aws_instance" "worker-2" {
  # Amazon Linux 2 
  # Todo: User filter 
  # Ubuntu 20.04
  ami           = "ami-0fffe3a460634f60c"
  instance_type = "t3.nano"
  key_name      = aws_key_pair.dev-key.id
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  # volume_type = "gp3"

  tags = {
    Name = "Worker-2"
  }

}

resource "aws_instance" "master" {
  # Amazon Linux 2 
  # Todo: User filter 
  # Ubuntu 20.04
  count = 1
  ami           = "ami-0fffe3a460634f60c"
  instance_type = "t3.nano"
  key_name      = aws_key_pair.dev-key.id
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  # volume_type = "gp3"

  tags = {
    Name = "Master"
  }

}



resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}

resource "aws_eip" "nat-gw" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-gw.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}