# Get the Linux AMI ID using SSM parameter 
data "aws_ssm_parameter" "LinuxAmi" {
  provider = aws.region_master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create key-pair for logging into EC2 instances in us-east-1 
resource "aws_key_pair" "vault-key" {
  provider   = aws.region_master
  key_name   = "hashi-vault"
  public_key = file("./vault_id_rsa.pub")
}

# create vault/consul instances 
resource "aws_instance" "vault-node" {
  provider                    = aws.region_master
  count                       = var.node_count
  ami                         = data.aws_ssm_parameter.LinuxAmi.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.vault-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.vault-sg.id]
  subnet_id                   = aws_subnet.vault_subnet1.id
  tags = {
    Name = join("_", ["vault_node_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]

  # Setup Consul and Vault 
  provisioner "local-exec" {
    command = <<EOF
        aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region_master} --instance-ids ${self.id}
        ansible-playbook -e 'passed_in_hosts=tag_Name_${self.tags.Name}' -e 'app_name=consul' -e "app_version=1.9.3" vault-plays/site.yml
        ansible-playbook -e 'passed_in_hosts=tag_Name_${self.tags.Name}' -e 'app_name=vault' -e "app_version=1.6.2" vault-plays/site.yml
      EOF
  }
}
