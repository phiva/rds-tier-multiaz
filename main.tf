terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Local variables for common tags
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  common_tags  = local.common_tags
}

# Subnets Module
module "subnets" {
  source = "./modules/subnets"

  vpc_id               = module.vpc.vpc_id
  project_name         = var.project_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = local.common_tags
}

# Routing Module
module "routing" {
  source = "./modules/routing"

  vpc_id              = module.vpc.vpc_id
  project_name        = var.project_name
  internet_gateway_id = module.vpc.internet_gateway_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  common_tags         = local.common_tags
}

# RDS Module - Multi-AZ PostgreSQL Database
module "rds" {
  source = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.subnets.private_subnet_ids
  project_name       = var.project_name
  environment        = var.environment

  # Database Configuration
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  storage_type      = var.rds_storage_type
  storage_encrypted = var.rds_storage_encrypted
  database_name     = var.rds_database_name
  master_username   = var.rds_master_username
  master_password   = var.rds_master_password

  # Network Configuration
  database_port       = var.rds_database_port
  allowed_cidr_blocks = [var.vpc_cidr]

  # High Availability
  multi_az                   = var.rds_multi_az
  publicly_accessible        = var.rds_publicly_accessible
  backup_retention_period    = var.rds_backup_retention_period
  auto_minor_version_upgrade = var.rds_auto_minor_version_upgrade
  deletion_protection        = var.rds_deletion_protection
  skip_final_snapshot        = var.rds_skip_final_snapshot

  # Enhanced Monitoring
  enable_enhanced_monitoring = var.rds_enable_enhanced_monitoring
}


