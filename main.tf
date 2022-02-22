resource "aws_vpc" "myVpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "igw"

  }
}

resource "aws_subnet" "mySubnet_1" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}

resource "aws_subnet" "mySubnet_2" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = "subnet"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myVpc.id
  route  = []
  tags = {
    Name = "example"

  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.rt]
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.mySubnet_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.mySubnet_2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name        = "allow_all_traffic"
  description = "allow all inbound traffic"
  vpc_id      = aws_vpc.myVpc.id

  ingress = [
    {
      description      = "all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_block       = ["0.0.0.0/0"]
      ipv6_cidr_block = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "outbound rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_block       = ["0.0.0.0/0"]
      ipv6_cidr_block = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null

    }
  ]
  tags = {
    Name = "all_traffic"
  }
}

resource "aws_instance" "ec2_1" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mySubnet_1.id
  key_name      = "jenkins_key"
  tags = {
    Name = "Honey"
  }
}

resource "aws_instance" "ec2_2" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mySubnet_2.id
  key_name      = "jenkins_key"
  tags = {
    Name = "Honey"
  }
}
