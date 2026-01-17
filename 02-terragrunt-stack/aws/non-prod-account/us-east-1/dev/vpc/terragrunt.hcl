terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=6.6.0"
}


include "root" {
    path   = find_in_parent_folders("root.hcl")
    expose = true
}

locals {
    # vpc_vars = yamldecode(file("${get_parent_terragrunt_dir()}/aws/conf.d/dev/dev-resources.yaml"))
    # azs = try(local.vpc_vars.azs, ["${include.root.locals.aws_region}a", "${include.root.locals.aws_region}b"])
    azs = try(include.root.locals.env_vars.azs, ["${include.root.locals.aws_region}a", "${include.root.locals.aws_region}b"])
}

inputs = {
    # name            = "${local.vpc_vars.name}"
    # cidr            = "${local.vpc_vars.cidr}"
    # azs             = "${local.azs}"
    # private_subnets = "${local.vpc_vars.private_subnets}"
    # public_subnets  = "${local.vpc_vars.public_subnets}"
    name            = "${include.root.locals.env_vars.name}"
    cidr            = "${include.root.locals.env_vars.cidr}"
    azs             = "${local.azs}"
    private_subnets = "${include.root.locals.env_vars.private_subnets}"
    public_subnets  = "${include.root.locals.env_vars.public_subnets}"
}