terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=6.6.0"
}


include "root" {
    path   = find_in_parent_folders("root.hcl")
    expose = true
}

locals {
    azs = try(include.root.locals.env_vars.vpc.azs, ["${include.root.locals.aws_region}a", "${include.root.locals.aws_region}b"])
}

inputs = {
    name            = "${include.root.locals.env_vars.vpc.name}"
    cidr            = "${include.root.locals.env_vars.vpc.cidr}"
    azs             = "${local.azs}"
    private_subnets = "${include.root.locals.env_vars.vpc.private_subnets}"
    public_subnets  = "${include.root.locals.env_vars.vpc.public_subnets}"
}