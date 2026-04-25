variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

# ==================== RDS Variables ====================

variable "rds_engine" {
  description = "RDS database engine (postgres, mysql, mariadb, oracle-se2, sqlserver-ex)"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "15.4"
}

variable "rds_instance_class" {
  description = "RDS instance class (e.g., db.t4g.micro, db.t4g.small, db.m6i.large)"
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "rds_storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "rds_database_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "rds_master_username" {
  description = "Master database username"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "rds_master_password" {
  description = "Master database password (min 8 characters, must include uppercase, lowercase, digit, special char)"
  type        = string
  sensitive   = true
}

variable "rds_database_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = true
}

variable "rds_publicly_accessible" {
  description = "Make RDS instance publicly accessible (not recommended for production)"
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "Number of days to retain automatic backups (1-35)"
  type        = number
  default     = 7
}

variable "rds_auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when destroying (not recommended for production)"
  type        = bool
  default     = false
}

variable "rds_enable_enhanced_monitoring" {
  description = "Enable RDS Enhanced Monitoring (CloudWatch Logs)"
  type        = bool
  default     = false
}

