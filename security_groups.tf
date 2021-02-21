resource "aws_security_group" "vault-sg" {
  provider    = aws.region_master
  name        = "vault-sg"
  description = "Allow port 8200 for Vault UI and SSH on port 22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 8200 from anywhere"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow ssh acccess from external IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb-sg" {
  provider    = aws.region_master
  name        = "lb-sg"
  description = "Route traffic to vault/consul instance(s)"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
