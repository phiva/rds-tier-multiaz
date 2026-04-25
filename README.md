# AWS VPC with Subnets & RDS - Modular Terraform

This Terraform configuration creates an AWS VPC with public and private subnets, Multi-AZ RDS database, organized using modular architecture for reusability and maintainability.

## Architecture

- **VPC Module**: Single VPC with configurable CIDR block and Internet Gateway
- **Subnets Module**: Public and private subnets across multiple availability zones
- **Routing Module**: NAT Gateways, Elastic IPs, and route tables with proper routing configurations
- **RDS Module**: Multi-AZ RDS database instance with automated backups and encryption
- **High Availability**: One NAT Gateway per public subnet + Multi-AZ RDS for redundancy

## Project Structure

```
.
├── main.tf                    # Root module configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Output definitions
├── terraform.tfvars           # Variable values
├── modules/
│   ├── vpc/
│   │   ├── main.tf           # VPC and Internet Gateway resources
│   │   ├── variables.tf       # VPC module variables
│   │   └── outputs.tf         # VPC module outputs
│   ├── subnets/
│   │   ├── main.tf           # Public and private subnet resources
│   │   ├── variables.tf       # Subnets module variables
│   │   └── outputs.tf         # Subnets module outputs
│   ├── routing/
│   │   ├── main.tf           # NAT Gateways, EIPs, and route tables
│   │   ├── variables.tf       # Routing module variables
│   │   └── outputs.tf         # Routing module outputs
│   └── rds/
│       ├── main.tf           # RDS instance, security group, subnet group
│       ├── variables.tf       # RDS module variables
│       ├── outputs.tf         # RDS module outputs
│       └── README.md          # RDS module documentation
└── README.md                  # This file
```

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create VPC, subnets, RDS, and related resources

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the plan

```bash
terraform plan
```

### 3. Apply the configuration

```bash
terraform apply
```

### 4. View outputs

```bash
terraform output
```

## Configuration

Edit `terraform.tfvars` to customize:

**Network Configuration:**
- `aws_region`: AWS region for resources (default: `us-east-1`)
- `project_name`: Prefix for resource names (default: `my-project`)
- `environment`: Environment identifier (dev/staging/prod) (default: `dev`)
- `vpc_cidr`: CIDR block for the VPC (default: `10.0.0.0/16`)
- `public_subnet_cidrs`: List of CIDR blocks for public subnets
- `private_subnet_cidrs`: List of CIDR blocks for private subnets

**RDS Configuration:**
- `rds_engine`: Database engine (postgres, mysql, mariadb, oracle-se2, sqlserver-ex) (default: `postgres`)
- `rds_engine_version`: Engine version (default: `15.4`)
- `rds_instance_class`: Instance class (db.t4g.micro, db.t4g.small, db.m6i.large, etc.)
- `rds_allocated_storage`: Storage in GB (default: `20`)
- `rds_storage_type`: Storage type (gp2, gp3, io1) (default: `gp3`)
- `rds_database_name`: Initial database name (default: `appdb`)
- `rds_master_username`: Database username (default: `postgres`)
- `rds_master_password`: **REQUIRED** - Database password (⚠️ Change from default!)
- `rds_multi_az`: Multi-AZ deployment (default: `true`)
- `rds_backup_retention_period`: Backup retention days (default: `7`)
- `rds_deletion_protection`: Enable deletion protection (default: `true`)

## Modules

### VPC Module (`modules/vpc/`)

**Resources Created:**
- AWS VPC with DNS support
- Internet Gateway

**Inputs:**
- `vpc_cidr`: CIDR block for VPC
- `project_name`: Project name for naming
- `common_tags`: Tags to apply to all resources

**Outputs:**
- `vpc_id`: VPC identifier
- `vpc_cidr`: VPC CIDR block
- `internet_gateway_id`: Internet Gateway ID

### Subnets Module (`modules/subnets/`)

**Resources Created:**
- Public subnets (with public IP assignment enabled)
- Private subnets
- Automatic AZ distribution

**Inputs:**
- `vpc_id`: VPC ID from VPC module
- `project_name`: Project name for naming
- `public_subnet_cidrs`: List of public subnet CIDRs
- `private_subnet_cidrs`: List of private subnet CIDRs
- `common_tags`: Tags to apply to all resources

**Outputs:**
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs

### Routing Module (`modules/routing/`)

**Resources Created:**
- NAT Gateways (one per public subnet)
- Elastic IPs for NAT Gateways
- Public route table with IGW route
- Private route tables with NAT Gateway routes
- Route table associations

**Inputs:**
- `vpc_id`: VPC ID
- `project_name`: Project name for naming
- `internet_gateway_id`: Internet Gateway ID
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs
- `common_tags`: Tags to apply to all resources

**Outputs:**
- `public_route_table_id`: Public route table ID
- `private_route_table_ids`: List of private route table IDs
- `nat_gateway_ips`: List of Elastic IPs (public IPs of NAT Gateways)

### RDS Module (`modules/rds/`)

**Resources Created:**
- Multi-AZ RDS database instance
- DB subnet group (private subnets)
- Security group for database access
- Enhanced monitoring IAM role (optional)

**Key Features:**
- Automatic failover with Multi-AZ
- Storage encryption at rest
- Automated backups with configurable retention
- Deletion protection
- Multiple database engine support

**Inputs:**
- `vpc_id`: VPC ID
- `private_subnet_ids`: Private subnets for DB subnet group
- `engine`: Database engine (default: postgres)
- `instance_class`: Instance type (default: db.t4g.micro)
- `master_password`: Database password (required, sensitive)
- And many more configurable options

**Outputs:**
- `db_instance_id`: RDS instance identifier
- `db_instance_endpoint`: Database endpoint (host:port)
- `db_instance_address`: Database hostname
- `rds_security_group_id`: Security group ID
- `connection_string`: Full connection string (PostgreSQL format, sensitive)

See `modules/rds/README.md` for complete RDS documentation.

## Root Level Outputs

**Network Outputs:**
- `vpc_id`: VPC identifier
- `vpc_cidr`: VPC CIDR block
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs
- `internet_gateway_id`: Internet Gateway ID
- `nat_gateway_ips`: Elastic IPs of NAT Gateways

**RDS Outputs:**
- `rds_db_instance_id`: RDS instance identifier
- `rds_db_instance_endpoint`: Connection endpoint (host:port)
- `rds_db_instance_address`: Database hostname
- `rds_security_group_id`: RDS security group ID
- `rds_connection_string`: Full connection string (sensitive)

## Deployment Example

```bash
# Initialize
terraform init

# Plan changes
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan

# Get database connection details
terraform output rds_db_instance_endpoint
terraform output rds_connection_string
```

## Connecting to the Database

After deployment, retrieve connection details:

```bash
# Get RDS endpoint
terraform output rds_db_instance_address

# Get full connection string
terraform output -raw rds_connection_string
```

### PostgreSQL Connection

```bash
psql -h $(terraform output -raw rds_db_instance_address) \
     -U postgres \
     -d appdb
```

### From EC2 Instance in VPC

```bash
psql -h my-project-db.c9akciq32.us-east-1.rds.amazonaws.com \
     -U postgres \
     -d appdb
```

## Security Best Practices

1. **⚠️ Change Default Password**: Update `rds_master_password` in `terraform.tfvars` immediately
2. **Multi-AZ**: Always enabled for production
3. **Encryption**: Storage encryption enabled by default
4. **Private Subnets**: RDS deployed only in private subnets
5. **Security Groups**: Restricted to VPC CIDR by default
6. **Backups**: 7-day retention default, increase for production
7. **Deletion Protection**: Enabled to prevent accidental deletion

## Cost Optimization

- **Development**: Use `db.t4g.micro` with `gp3` storage
- **Production**: Consider `db.t4g.small` or larger depending on workload
- **Storage**: `gp3` provides better price/performance than `gp2`
- **Backups**: Adjust retention period based on recovery requirements
- **Monitoring**: Disable `enable_enhanced_monitoring` if not needed

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Modular Architecture Benefits

1. **Reusability**: Modules can be used in other projects
2. **Maintainability**: Each module has a single responsibility
3. **Scalability**: Easy to add new modules (Security Groups, Application Load Balancer, etc.)
4. **Testability**: Modules can be tested independently
5. **Consistency**: Common tagging and configuration applied across all resources
6. **Flexibility**: Override defaults through variables as needed

## Common Operations

### Create database backup

RDS automatic backups are enabled. Manual snapshots can be created via AWS Console or:

```bash
aws rds create-db-snapshot --db-instance-identifier my-project-db \
    --db-snapshot-identifier my-project-db-snapshot-$(date +%Y%m%d-%H%M%S)
```

### Scale instance class

Update `rds_instance_class` in `terraform.tfvars`:

```bash
terraform plan  # Review changes
terraform apply # Apply the upgrade (causes brief downtime)
```

### Modify backup retention

Update `rds_backup_retention_period` in `terraform.tfvars`:

```bash
terraform apply
```

## Troubleshooting

### Cannot connect to RDS

1. Check security group allows inbound on database port (5432 for PostgreSQL)
2. Ensure client is in same VPC or has network connectivity
3. Verify database credentials
4. Check RDS is not being created (check CloudFormation events)

### RDS creation takes too long

RDS instances typically take 5-10 minutes to create. Use:

```bash
terraform show  # View current state
aws rds describe-db-instances --db-instance-identifier my-project-db
```

## Related Resources

- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [Terraform AWS Provider - RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [RDS Best Practices](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)


