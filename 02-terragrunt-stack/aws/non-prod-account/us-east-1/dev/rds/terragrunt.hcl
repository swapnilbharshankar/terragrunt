terraform {
    source = "${find_in_parent_folders("modules")}/rds"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "security_group" {
  config_path = "../security-groups"
}

inputs = {
    identifier              = include.root.locals.env_vars.common.name
    engine                  = include.root.locals.env_vars.rds.engine
    engine_version          = include.root.locals.env_vars.rds.engine_version
    instance_class          = include.root.locals.env_vars.rds.instance_class
    allocated_storage       = include.root.locals.env_vars.rds.allocated_storage

    db_name                 = include.root.locals.env_vars.rds.db_name
    username                = include.root.locals.env_vars.rds.username
    password                = include.root.locals.env_vars.rds.password # Use a more secure method for production

    # Network and security settings
    vpc_id                  = dependency.vpc.outputs.vpc_id
    # vpc_security_group_ids  = [aws_security_group.this.id]
    subnet_ids              = dependency.vpc.outputs.private_subnets
    private_cidr_blocks     = dependency.vpc.outputs.private_subnets_cidr_blocks
    tags                    = include.root.locals.env_vars.common.tags
}