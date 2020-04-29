# The main VPC with one public subnet.
resource "aws_vpc" "web" {
  cidr_block         = var.vpc_cidr_block
  instance_tenancy   = "default"
  enable_dns_support = true

  tags = {
    Name    = "web"
    BuiltBy = "terraform"
  }
}

resource "aws_internet_gateway" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name    = "web-main"
    BuiltBy = "Terraform"
  }
}

# The public one
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.web.id
  cidr_block              = var.public_cidr_block
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name    = "web-public"
    Type    = "public"
    BuiltBy = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.web.id
  }

  tags = {
    Name    = "web-public"
    BuiltBy = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow TLS inbound traffic."
  vpc_id      = aws_vpc.web.id

  ingress {
    description = "For accessing web."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "For ecs to pull image."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "web"
    BuiltBy = "Terraform"
  }
}
