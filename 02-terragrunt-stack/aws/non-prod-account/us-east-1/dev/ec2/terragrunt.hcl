terraform {
  source = "${find_in_parent_folders("modules")}/ec2"
}


include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}


dependency "key_pair" {
  config_path = "../key-pair"
}


dependency "vpc" {
  config_path = "../vpc"
}


dependency "security_group" {
  config_path = "../security-groups"
}


inputs = {
  name            = "swapnil-${include.root.locals.account_name}-${include.root.locals.env}"
  ami             = "ami-0ff8a91507f77f867"
  key_name        = dependency.key_pair.outputs.key_pair_name
  subnet_id       = dependency.vpc.outputs.public_subnets[0]
  security_groups = [dependency.security_group.outputs.security_group_id]
}