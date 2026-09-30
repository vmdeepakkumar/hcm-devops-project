resource "aws_security_group" "hcm_ec2_sg" {
  name        = "hcm-ec2-sg"
  description = "Security group for HMSCI application EC2"
  vpc_id      = aws_vpc.hcm_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HMSCI Flask Application"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "hcm-ec2-sg"
    Project     = "HMSCI"
    Environment = "Dev"
  }
}