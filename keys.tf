resource "tls_private_key" "jkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "tls_private_key" "web1_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "tls_private_key" "web2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "secret_key" {
  key_name   = "jenkinskey"
  public_key = tls_private_key.jkey.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.jkey.private_key_pem
  sensitive = true
}

resource "aws_key_pair" "web1_key_pair" {
  key_name   = "web1_key"
  public_key = tls_private_key.web1_key.public_key_openssh
}
resource "aws_key_pair" "web2_key_pair" {
  key_name   = "web2_key"
  public_key = tls_private_key.web2_key.public_key_openssh
}
output "web1_private_key" {
  value     = tls_private_key.web1_key.private_key_pem
  sensitive = true
}
output "web2_private_key" {
  value     = tls_private_key.web2_key.private_key_pem
  sensitive = true
}
