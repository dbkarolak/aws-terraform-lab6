resource "aws_instance" "web1" {
  ami           = "ami-0440d3b780d96b29d" # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_a.id
  security_groups = [aws_security_group.web_sg.id]
  key_name      = aws_key_pair.web1_key_pair.key_name
  tags = {
    Name = "Production_Env1"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.web1_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "chmod +x ./getkey.sh && ./getkey.sh web1_key.pem"
  }

  provisioner "file" {
    source      = "server1/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo mv /tmp/index.html /var/www/html/",
      "sudo chown apache:apache /var/www/html/index.html"
    ]
  }
}

resource "aws_instance" "web2" {
  ami           = "ami-0440d3b780d96b29d" # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_b.id
  security_groups = [aws_security_group.web_sg.id]
  key_name      = aws_key_pair.web2_key_pair.key_name
  tags = {
    Name = "Production_Env2"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.web2_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "chmod +x ./getkey.sh && ./getkey.sh web2_key.pem"
  }

  provisioner "file" {
    source      = "server2/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo mv /tmp/index.html /var/www/html/",
      "sudo chown apache:apache /var/www/html/index.html"
    ]
  }
}

resource "aws_instance" "web3_testing_env" {
  ami           = "ami-0440d3b780d96b29d" # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_b.id
  security_groups = [aws_security_group.web_sg.id]
  key_name      = aws_key_pair.secret_key.key_name
  tags = {
    Name = "Testing_Env"
  }
}

resource "aws_instance" "web4_staging_env" {
  ami           = "ami-0440d3b780d96b29d" # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_b.id
  security_groups = [aws_security_group.web_sg.id]
  key_name      = aws_key_pair.secret_key.key_name
  tags = {
    Name = "Staging_Env"
  }
}

