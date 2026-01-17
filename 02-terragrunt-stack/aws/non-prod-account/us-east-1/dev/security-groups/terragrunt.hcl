terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/security-group/aws//?version=5.1.2"
}


include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}


dependency "vpc" {
  config_path = "../vpc"
}


inputs = {
  name   = "swapnil-${include.root.locals.account_name}-${include.root.locals.env}"
  vpc_id = dependency.vpc.outputs.vpc_id
}