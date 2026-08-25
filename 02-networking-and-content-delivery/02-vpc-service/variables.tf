#Region
variable "aws_region" {
  description = "region"
  type        = string
  default     = "ap-southeast-3"
}

# Environment
variable "environment" {
  description = "ENV Name (dev, stag, prod)"
  type        = string
  default     = "dev"
}

#Project Name
variable "project_name" {
  description = "Service Name"
  type        = string
  default     = "portofolio"
}

variable "vpc_cidr" {
  description = "CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet" {
  description   = "List of Public Subnet"
  type          = map(object({
    cidr_block  = string
    az          = string
  }))
  default       = {
    "public-a"  = { cidr_block = "10.0.10.0/24", az = "ap-southeast-3a"}
    "public-b"  = { cidr_block = "10.0.20.0/24", az = "ap-southeast-3b"}
    "public-c"  = { cidr_block = "10.0.30.0/24", az = "ap-southeast-3c"}
  }
}

variable "private_subnet" {
  description   = "List of Private Subnet"
  type          = map(object({
    cidr_block  = string
    az          = string
  }))
  default       = {
    "private-a" = { cidr_block = "10.0.1.0/24", az = "ap-southeast-3a"}
    "private-b" = { cidr_block = "10.0.2.0/24", az = "ap-southeast-3b"}
    "private-c" = { cidr_block = "10.0.3.0/24", az = "ap-southeast-3c"}
  }
}

variable "enable_nat_gateway" {
  description   = "NAT Gateway"
  type          = bool
  default       = false
}

variable "single_nat_gateway" {
  description   = "only for 1 nat gateway for cost optimize"
  type          = bool
  default       = false
}
variable "security_group_rules" {
  description   = "List of ingress rules"
  type          = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
        description = "HTTP Allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        description = "HTTPS Allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        description = "SSH Allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]# Better use your ip public
    }
  ]
}

variable "tags" {
  description = "Map tag tambahan (key-value), akan digabung ke semua resource"
  type        = map(string)
  default     = {}
}