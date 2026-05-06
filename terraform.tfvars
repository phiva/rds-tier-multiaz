aws_region           = "us-east-1"
project_name         = "my-project"
environment          = "dev"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# ==================== RDS Configuration ====================

rds_engine                     = "mysql"
rds_engine_version             = "8.0.45"
rds_instance_class             = "db.t4g.micro"
rds_allocated_storage          = 20
rds_storage_type               = "gp3"
rds_storage_encrypted          = true
rds_database_name              = "appdb"
rds_master_username            = "admin"
rds_master_password            = "ChangeMe!123456" # CHANGE THIS IN PRODUCTION - Use strong password
rds_database_port              = 3306
rds_multi_az                   = true
rds_publicly_accessible        = false
rds_backup_retention_period    = 7
rds_auto_minor_version_upgrade = true
rds_deletion_protection        = false
rds_skip_final_snapshot        = false
rds_enable_enhanced_monitoring = false

