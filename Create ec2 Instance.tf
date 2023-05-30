locals {
  instances = {
    "0" = "Kops",

  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  for_each = local.instances

  name = each.key

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.kops.key_name
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg.security_group_id]

  // Use modulo to distribute instances across different AZs
  subnet_id = module.vpc.public_subnets[each.key]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x ./kubectl
              sudo mv ./kubectl /usr/local/bin/kubectl
              curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
              chmod +x kops-linux-amd64
              sudo mv kops-linux-amd64 /usr/local/bin/kops
              EOF
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = each.value
  }
}

data "aws_instance" "created_instances" {
  for_each = module.ec2_instance

  instance_id = each.value.id
}
