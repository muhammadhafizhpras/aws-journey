# PROVIDERS
variable "aws_region" {
  description = "Region"
  type        = string
  default     = "ap-southeast-3"
}

variable "project_name" {
  description = "Name Project"
  type = string
  default = "portofolio"
}

variable "environment" {
  description = "ENV Name"
  type = string
  default = "prod"

  validation {
    condition = contains (["dev","stag","prod"], var.environment)
    error_message = "Environtment : dev, stag, prod"
  }
}

# NETWORKING
variable "vpc_cidr" {
  description = "CIDR VPC Block"
  type = string
  default = "10.0.0.0/16"
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
    description = "Nat Gateway"
    type = bool
    default = false
}

variable "single_nat_gateway" {
  description = "Only Single Nat Gateway not 3"
  type = bool
  default = false
}

# SECURITY GROUP
variable "security_group" {
  description = "Security Group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [ 
    {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    },
    {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    },
    {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    } 
  ]
}

# KEY PAIR
variable "key_name" {
  description = "Key Pair for SSH Access"
  type = string
  default = "Name-Key"
}

#COMPUTE
variable "ec2_instance" {
  type = map(object({
    instance_type = string
    subnet_type   = string
    subnet_key    = string
    public_ip     = bool
    role          = string 
    key_name      = string
  }))
  default = {
    database = {
        instance_type = "t3.micro"
        subnet_key    = "private-a"
        public_ip     = false
        subnet_type   = "private"
        role          = "Database Server"
        key_name      = "database-key"
    }
  }
}

# TAGGING
variable "tags" {
  description = "Map tag tambahan (key-value), akan digabung ke semua resource"
  type        = map(string)
  default     = {}
}