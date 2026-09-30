data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "hcm_ec2" {
  ami           = data.aws_ssm_parameter.al2023_ami.value
  instance_type = "t3.micro"

  subnet_id = aws_subnet.hcm_public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.hcm_ec2_sg.id
  ]

  key_name = "hmsci-ec2-key"

  associate_public_ip_address = true

  tags = {
    Name        = "hcm-ec2"
    Project     = "HMSCI"
    Environment = "Dev"
  }
}