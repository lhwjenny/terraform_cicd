resource "aws_instance" "web" {
  ami                    = "ami-0a63f1b6e617f0f4e" # 서울 리전 예시
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.tag}-EC2"
  }
}
