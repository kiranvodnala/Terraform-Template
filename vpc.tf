>>>>>>>>vpc.tf<<<<<<<<

provider "aws" {
  region = "us-east-1"
  access_key = "ACCESS KEY"
  secret_key = "SECRET KEY"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-sub"
  }
}

resource "aws_instance" "web-server" {
  count = 1
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "web-server"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "private sub"
  }
}

resource "aws_instance" "app-server" {
  count = 1
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  tags = {
    Name = "app-server"
  }
}


resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-RT"
  }
}

resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "MY-IGW"
  }
}


resource "aws_internet_gateway_attachment" "igw" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id = aws_vpc.main.id
}


resource "aws_route" "public-RT" {
  route_table_id = aws_route_table.public-RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}



resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private-RT.id
}

terraform init
terraform validate
terraform plan
terraform apply
