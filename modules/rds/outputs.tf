output "db_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.main.id
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint (connection string)"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "RDS instance address (hostname)"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "db_instance_resource_id" {
  description = "RDS instance resource ID"
  value       = aws_db_instance.main.resource_id
}

output "db_subnet_group_id" {
  description = "DB subnet group ID"
  value       = aws_db_subnet_group.main.id
}

output "rds_security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}

output "db_instance_allocated_storage" {
  description = "Allocated storage in GB"
  value       = aws_db_instance.main.allocated_storage
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.main.arn
}

output "connection_string" {
  description = "Connection string for the database"
  value       = "postgresql://${var.master_username}@${aws_db_instance.main.endpoint}/${var.database_name}"
  sensitive   = true
}
