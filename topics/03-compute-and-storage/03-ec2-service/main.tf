# KEY PAIR
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = var.key_name
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_sensitive_file" "private_key_pem" {
  content = tls_private_key.key_pair.private_key_pem
  filename = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# VPC
resource "aws_vpc" "main" {
    cidr_block            = var.vpc_cidr
    enable_dns_support    = true
    enable_dns_hostnames = true

    tags = merge(local.common_tags, {
        Name = "${local.name_resource}"
    })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id  = aws_vpc.main.id

    tags = merge(local.common_tags, {
        Name = "${local.name_resource}"
    })
}

# Public Subnet
resource "aws_subnet" "public" {
    for_each    = var.public_subnet

    vpc_id                  = aws_vpc.main.id
    cidr_block              = each.value.cidr_block
    availability_zone       = each.value.az
    map_public_ip_on_launch = true


     tags = merge(local.common_tags, {
        Name = "${local.name_resource}-public-${each.key}"
        Tier = "public"
    }) 
}

# Private Subnet
resource "aws_subnet" "private" {
    for_each    = var.private_subnet

    vpc_id            = aws_vpc.main.id
    cidr_block        = each.value.cidr_block
    availability_zone = each.value.az

     tags = merge(local.common_tags, {
        Name = "${local.name_resource}-private-${each.key}"
        Tier = "private"
    }) 
}

#Nat Gateway
resource "aws_eip" "nat" {
    for_each    = var.enable_nat_gateway ? local.nat_gateway_map : {}
    domain      = "vpc"

    tags = merge(local.common_tags, {
        Name = "${local.name_resource}-nat-${each.key}"
    })
}


resource "aws_nat_gateway" "main" {
    for_each = var.enable_nat_gateway ? local.nat_gateway_map : {}
    allocation_id = aws_eip.nat[each.key].id
    subnet_id     = aws_subnet.public[each.key].id

    tags = merge(local.common_tags, {
        Name = "${local.name_resource}"
    })

    depends_on = [aws_internet_gateway.main]
}


#Route Table
resource "aws_route_table" "public" {
    vpc_id  = aws_vpc.main.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.main.id
    }

    tags = merge(local.common_tags, {
        Name = "${local.name_resource}-rt-public"
    })
}

#Route Table Association
resource "aws_route_table_association" "public" {
    for_each       = aws_subnet.public
    subnet_id      = each.value.id
    route_table_id = aws_route_table.public.id
}

# Route Table Private
resource "aws_route_table" "private" {
    for_each    = var.private_subnet
    vpc_id      = aws_vpc.main.id

    tags = merge(local.common_tags, {
        Name = "${local.name_resource}-rt-${each.key}"
    })
}

# Route Private
resource "aws_route" "private_nat" {
  for_each = var.enable_nat_gateway ? var.private_subnet : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.single_nat_gateway ? values(aws_nat_gateway.main)[0].id : lookup(
    local.nat_gateway_by_az,
    each.value.az,
    values(aws_nat_gateway.main)[0].id
  )
}

# Route Table Association Private
resource "aws_route_table_association" "private" {
    for_each        = aws_subnet.private
    subnet_id       = each.value.id
    route_table_id  = aws_route_table.private[each.key].id
}

# Security Group
resource "aws_security_group" "app" {
    name        = "${local.name_resource}-app-sg"
    description = "SG for APP"
    vpc_id      = aws_vpc.main.id

    dynamic "ingress" {
        for_each = var.security_group
        content {
            description = ingress.value.description
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }

    egress {
        description = "Allow ALL Traffic Out"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = merge(local.common_tags , {
        Name = "${local.name_resource}-app-sg"
    })
}

# EC2

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "ec2" {
  for_each      = var.ec2_instance
  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_type
  subnet_id = each.value.subnet_type == "public" ? (
    aws_subnet.public[each.value.subnet_key].id
  ) : (
    aws_subnet.private[each.value.subnet_key].id
  )

  tags = merge(local.common_tags, {
    Name = "${local.name_resource}-${each.key}"
    Role = each.value.role
  })
}