terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=6.6.0"
}


include "root" {
    path   = find_in_parent_folders("root.hcl")
    expose = true
}

locals {
    vpc_vars = yamldecode(file("${get_terragrunt_dir()}/vpc.yaml"))
}

# inputs = {
#     name            = "swapnil-${include.root.locals.account_vars.locals.account_name}-${include.root.locals.region_vars.locals.aws_region}-${include.root.locals.env_vars.locals.env}.vpc"
#     cidr            = "10.64.0.0/16"
#     azs             = ["${include.root.locals.region_vars.locals.aws_region}a", "${include.root.locals.region_vars.locals.aws_region}b"]
#     private_subnets = ["10.64.0.0/24", "10.64.1.0/24"]
#     public_subnets  = ["10.64.2.0/24", "10.64.3.0/24"]
# }
inputs = {
    name            = "${local.vpc_vars.name}"
    cidr            = "${local.vpc_vars.cidr}"
    azs             = "${local.vpc_vars.azs}"
    private_subnets = "${local.vpc_vars.private_subnets}"
    public_subnets  = "${local.vpc_vars.public_subnets}"
}