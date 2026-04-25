# Module Architecture Overview

This document provides a quick reference for the modular Terraform structure.

## Module Dependency Graph

```
Root Configuration (main.tf)
    ↓
    ├─→ VPC Module (modules/vpc)
    │       Outputs: vpc_id, internet_gateway_id, vpc_cidr
    │
    ├─→ Subnets Module (modules/subnets)
    │       Inputs: vpc_id (from VPC module)
    │       Outputs: public_subnet_ids, private_subnet_ids
    │
    └─→ Routing Module (modules/routing)
            Inputs: vpc_id, internet_gateway_id, subnet IDs
            Outputs: route_table_ids, nat_gateway_ips
```

## Module Responsibilities

### VPC Module
- Creates the VPC with DNS configuration
- Creates the Internet Gateway
- Responsible for core networking infrastructure

### Subnets Module
- Creates public subnets with auto-assign public IP
- Creates private subnets
- Distributes subnets across availability zones
- Independent from routing logic

### Routing Module
- Creates NAT Gateways for private subnets
- Allocates and manages Elastic IPs
- Creates and manages route tables
- Configures routing rules for public and private traffic

## Adding New Modules

To add additional functionality, create new modules following this pattern:

```bash
mkdir -p modules/<new-module>
touch modules/<new-module>/{main.tf,variables.tf,outputs.tf}
```

Example new modules:
- `modules/security-groups/` - For security group management
- `modules/nat-instance/` - For EC2-based NAT alternatives
- `modules/vpc-flow-logs/` - For VPC Flow Logs
- `modules/endpoints/` - For VPC endpoints (S3, DynamoDB, etc.)

## Input Variables Flow

```
terraform.tfvars (user-provided values)
    ↓
Root variables.tf (declares all inputs)
    ↓
main.tf (passes to modules via locals and direct references)
    ↓
Module variables.tf (each module declares its inputs)
    ↓
Module main.tf (uses variables to create resources)
```

## Output Aggregation

```
Module Outputs (individual module outputs.tf)
    ↓
Root outputs.tf (aggregates and exposes module outputs)
    ↓
Terraform output command / Reference in other projects
```

## Scaling Considerations

### For Multi-Environment Setup

Create separate directories:
```
environments/
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
└── prod/
    ├── main.tf
    ├── variables.tf
    └── terraform.tfvars
```

### For Shared Module Library

Move modules to a separate repository:
```hcl
module "vpc" {
  source = "git::https://github.com/org/terraform-modules.git//vpc?ref=v1.0.0"
  # ...
}
```

## Best Practices Applied

1. **Single Responsibility**: Each module has one primary purpose
2. **Clear Interfaces**: Well-defined inputs and outputs
3. **Consistent Naming**: Resource names follow project naming conventions
4. **Tag Strategy**: Common tags applied across all resources
5. **DRY Code**: Reusable components, no duplication
6. **Documentation**: Each module is documented
7. **Version Constraints**: Terraform version and provider versions specified
