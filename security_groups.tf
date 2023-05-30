module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "kops-instances-sg"
  description         = "Security group for webpress-instances,bastion"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [
    # SSH
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

