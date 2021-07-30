provider "aws" {
  region = "ap-southeast-1"
}


module "vpc" {
  source = "..\/..\/.."
  owner = "samuel"
  project_name = "demo-vpc"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}


output "vpc_name" {
  value = "demo-vpc"
}

output "security_group_ids" {
  value = module.vpc.security_group_ids
}

