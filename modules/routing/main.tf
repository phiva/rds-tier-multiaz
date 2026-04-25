# Routing Module - main.tf

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-eip-${count.index + 1}"
    }
  )

  depends_on = [var.internet_gateway_id]
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-nat-${count.index + 1}"
    }
  )

  depends_on = [var.internet_gateway_id]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = var.internet_gateway_id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-public-rt"
      Type = "Public"
    }
  )
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Private Route Tables (one per AZ for NAT Gateway redundancy)
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_ids)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-private-rt-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}
