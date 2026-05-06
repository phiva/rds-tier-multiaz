variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "engine" {
  description = "RDS database engine (mysql, postgres, mariadb, oracle-se2, sqlserver-ex)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "8.0.45"
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t4g.micro, db.t4g.small, db.m6i.large)"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "myappdb"
}

variable "master_username" {
  description = "Master database username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "master_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "database_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/16"] # VPC CIDR by default
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Make RDS instance publicly accessible (not recommended for prod)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automatic backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying (not recommended for prod)"
  type        = bool
  default     = false
}

variable "enable_enhanced_monitoring" {
  description = "Enable RDS Enhanced Monitoring"
  type        = bool
  default     = false
}
