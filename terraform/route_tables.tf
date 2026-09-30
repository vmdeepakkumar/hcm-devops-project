resource "aws_route_table" "hcm_public_route_table" {
  vpc_id = aws_vpc.hcm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hcm_igw.id
  }

  tags = {
    Name        = "hcm-public-route-table"
    Project     = "HMSCI"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "hcm_public_subnet_association" {
  subnet_id      = aws_subnet.hcm_public_subnet.id
  route_table_id = aws_route_table.hcm_public_route_table.id
}