output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "vote_service_sg_id" {
  value = module.vote_service_sg.security_group_id
}

output "key_pair_name" {
  description = "The key pair name"
  value       = aws_key_pair.kops.key_name
}


output "Kops_instance_ips" {
  description = "The public IP address of the Kops instance."
  value       = [for instance in module.ec2_instance : instance.public_ip]
}

output "zone_id" {
  description = "The Zone ID of the created Hosted Zone"
  value       = aws_route53_zone.my_zone.zone_id
}

output "name_servers" {
  description = "The Name Servers of the created Hosted Zone"
  value       = aws_route53_zone.my_zone.name_servers
}

