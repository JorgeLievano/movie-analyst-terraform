resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags = merge(
    var.aws_default_tags,
    {
      Name = "jorgelievanos-rampup"
    },
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_vpc.main]
  tags = merge(
    var.aws_default_tags,
    {
      Name = "igw-jorgelievanos_rampup"
    },
  )
}

resource "aws_default_route_table" "drt_public" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  depends_on = [aws_internet_gateway.gw]
  tags = merge(
    var.aws_default_tags,
    {
      Name = "rt-jorgelievanos_rampup-public"
    },
  )
}

resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.0.0/21"
  map_public_ip_on_launch = true
  tags = merge(
    var.aws_default_tags,
    {
      Name = "subnet-jorgelievanos_rampup-public"
    },
  )
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
  tags = merge(
    var.aws_default_tags,
    {
      Name = "eip-nat-jorgelievanos_rampup"
    },
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet_public.id
  depends_on    = [aws_eip.eip, aws_subnet.subnet_public]
  tags = merge(
    var.aws_default_tags,
    {
      Name = "nat-jorgelievanos_rampup"
    },
  )
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  depends_on = [aws_nat_gateway.nat]
  tags = merge(
    var.aws_default_tags,
    {
      Name = "rt-jorgelievanos_rampup-private"
    },
  )
}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.80.0/21"
  tags = merge(
    var.aws_default_tags,
    {
      Name = "subnet-jorgelievanos_rampup-private"
    },
  )
}

resource "aws_route_table_association" "rt_association_subnet_private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rt_private.id
  depends_on     = [aws_route_table.rt_private, aws_subnet.subnet_private]
}