variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ops_user" {
    type = string
    description = "Unique identifying name for ops person running the AMI build"
}

variable "environment" {
    type = string
    description = "Environment account where the AMI is being created (Dev/Staging/Prod)"
    default = "Dev"
}
