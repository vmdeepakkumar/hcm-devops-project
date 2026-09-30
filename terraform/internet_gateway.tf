resource "aws_internet_gateway" "hcm_igw" {
  vpc_id = aws_vpc.hcm_vpc.id

  tags = {
    Name        = "hcm-internet-gateway"
    Project     = "HMSCI"
    Environment = "Dev"
  }
}