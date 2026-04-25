output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.subnets.private_subnet_ids
}

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways"
  value       = module.routing.nat_gateway_ips
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.routing.public_route_table_id
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = module.routing.private_route_table_ids
}

# ==================== RDS Outputs ====================

output "rds_db_instance_id" {
  description = "RDS instance identifier"
  value       = module.rds.db_instance_id
}

output "rds_db_instance_endpoint" {
  description = "RDS instance endpoint (connection string)"
  value       = module.rds.db_instance_endpoint
}

output "rds_db_instance_address" {
  description = "RDS instance address (hostname)"
  value       = module.rds.db_instance_address
}

output "rds_db_instance_port" {
  description = "RDS instance port"
  value       = module.rds.db_instance_port
}

output "rds_security_group_id" {
  description = "Security group ID for RDS"
  value       = module.rds.rds_security_group_id
}

output "rds_db_subnet_group_id" {
  description = "DB subnet group ID"
  value       = module.rds.db_subnet_group_id
}

output "rds_connection_string" {
  description = "Connection string for the RDS database"
  value       = module.rds.connection_string
  sensitive   = true
}

