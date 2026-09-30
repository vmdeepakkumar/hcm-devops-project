resource "aws_subnet" "hcm_public_subnet" {
  vpc_id                  = aws_vpc.hcm_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-2a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "hcm-public-subnet"
    Project     = "HMSCI"
    Environment = "Dev"
    Tier        = "Public"
  }
}

resource "aws_subnet" "hcm_private_subnet" {
  vpc_id            = aws_vpc.hcm_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-2b"

  tags = {
    Name        = "hcm-private-subnet"
    Project     = "HMSCI"
    Environment = "Dev"
    Tier        = "Private"
  }
}