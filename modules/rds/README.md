# AWS RDS Multi-AZ Module

This Terraform module creates an AWS RDS (Relational Database Service) instance with Multi-AZ deployment for high availability and disaster recovery.

## Features

- **Multi-AZ Deployment**: Automatic failover to standby replica in another availability zone
- **Storage Encryption**: EBS encryption at rest
- **Automated Backups**: Configurable retention period (1-35 days)
- **Security**: Security group integrated with VPC
- **Database Subnet Group**: Spans private subnets across multiple AZs
- **Enhanced Monitoring**: Optional CloudWatch monitoring (requires IAM role)
- **Deletion Protection**: Prevents accidental instance deletion
- **Flexible Configuration**: Supports multiple database engines (PostgreSQL, MySQL, MariaDB, Oracle, SQL Server)

## Supported Database Engines

- `postgres` - PostgreSQL (default)
- `mysql` - MySQL
- `mariadb` - MariaDB
- `oracle-se2` - Oracle SE2
- `sqlserver-ex` - SQL Server Express

## Module Usage

```hcl
module "rds" {
  source = "./modules/rds"

  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.subnets.private_subnet_ids
  project_name        = "my-project"
  environment         = "prod"

  # Database Configuration
  engine              = "postgres"
  engine_version      = "15.4"
  instance_class      = "db.t4g.small"
  allocated_storage   = 100
  database_name       = "appdb"
  master_username     = "postgres"
  master_password     = var.db_password

  # High Availability
  multi_az            = true
  backup_retention_period = 30
  deletion_protection = true
}
```

## Variables

### Required

- `vpc_id` - VPC ID where RDS will be deployed
- `private_subnet_ids` - List of private subnet IDs for RDS subnet group
- `project_name` - Project name for resource naming
- `environment` - Environment name (dev, staging, prod)
- `master_password` - Master database password

### Optional with Sensible Defaults

- `engine` - Database engine (default: `postgres`)
- `engine_version` - Engine version (default: `15.4` for PostgreSQL)
- `instance_class` - Instance class (default: `db.t4g.micro`)
- `allocated_storage` - Storage in GB (default: `20`)
- `storage_type` - Storage type: gp2, gp3, io1 (default: `gp3`)
- `storage_encrypted` - Enable encryption (default: `true`)
- `database_name` - Initial database name (default: `myappdb`)
- `master_username` - Master username (default: `admin`)
- `database_port` - Database port (default: `5432` for PostgreSQL)
- `allowed_cidr_blocks` - CIDR blocks allowed to access DB (default: VPC CIDR)
- `multi_az` - Enable Multi-AZ (default: `true`)
- `publicly_accessible` - Public access (default: `false`)
- `backup_retention_period` - Backup retention days (default: `7`)
- `backup_window` - Preferred backup window (default: `03:00-04:00` UTC)
- `maintenance_window` - Preferred maintenance window (default: `sun:04:00-sun:05:00` UTC)
- `auto_minor_version_upgrade` - Auto upgrade (default: `true`)
- `deletion_protection` - Enable deletion protection (default: `true`)
- `skip_final_snapshot` - Skip final snapshot on destroy (default: `false`)
- `enable_enhanced_monitoring` - Enhanced monitoring (default: `false`)

## Outputs

- `db_instance_id` - RDS instance identifier
- `db_instance_endpoint` - Connection endpoint (host:port)
- `db_instance_address` - Database hostname
- `db_instance_port` - Database port
- `db_subnet_group_id` - DB subnet group ID
- `rds_security_group_id` - Security group ID
- `db_instance_arn` - RDS instance ARN
- `connection_string` - Full connection string (PostgreSQL format)

## Security Best Practices

1. **Multi-AZ**: Always enable in production for high availability
2. **Encryption**: Keep storage encryption enabled
3. **Backups**: Use appropriate retention period (30+ days for production)
4. **Publicly Accessible**: Set to `false` in production
5. **Network**: Place in private subnets, not internet-accessible
6. **Passwords**: Use strong passwords with special characters, numbers, and mixed case
7. **Deletion Protection**: Enable for production instances
8. **Parameter Groups**: Customize for your workload requirements

## Connection Examples

### PostgreSQL

```bash
psql -h my-project-db.c9akciq32.us-east-1.rds.amazonaws.com -U postgres -d appdb
```

### MySQL

```bash
mysql -h my-project-db.c9akciq32.us-east-1.rds.amazonaws.com -u admin -p appdb
```

## Troubleshooting

### Cannot Connect to Database

1. Verify security group allows inbound traffic on database port
2. Ensure application/client is in same VPC or has network connectivity
3. Check database credentials
4. Verify parameter group settings don't restrict connections

### Performance Issues

1. Check instance class is appropriate for workload
2. Review CloudWatch metrics for CPU, memory, I/O
3. Monitor connection count
4. Check slow query logs

### Backup Issues

1. Verify backup retention period is set
2. Ensure adequate storage for backups
3. Check backup window doesn't overlap with heavy usage

## Cost Optimization

- Use `db.t4g.micro` or `db.t4g.small` for development/test
- Use `gp3` for storage type (better price/performance than gp2)
- Disable `enable_enhanced_monitoring` if not needed
- Set `skip_final_snapshot = true` for dev environments to reduce costs
- Use appropriate backup retention (shorter for dev, longer for prod)

## Related Modules

- VPC Module - Creates VPC and subnets
- Routing Module - Creates route tables and NAT gateways
