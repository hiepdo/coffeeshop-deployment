
resource "aws_instance" "dev" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker awscli jq
              service docker start
              usermod -aG docker ec2-user
              curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              # Log in to ECR
              # aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 522569276716.dkr.ecr.us-east-1.amazonaws.com
              
              # Verify internet connectivity
              ping -c 4 google.com >> /var/log/internet_check.log
              EOF
  tags = {
    Name = "${var.env}-ec2-${count.index + 1}"
  }
}