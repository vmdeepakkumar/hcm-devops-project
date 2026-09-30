resource "aws_vpc" "hcm_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "hcm-vpc"
    Project     = "HMSCI"
    Environment = "Dev"
  }
}