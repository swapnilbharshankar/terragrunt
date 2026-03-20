terraform {
    source = "git::https://github.com/swapnilbharshankar/infrastructureascode-terraform//azure/network?ref=main"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

locals {
    #common_vars = yamldecode(file("${get_parent_terragrunt_dir()}/${include.root.locals.cloud}/conf.d/${include.root.locals.env}/${include.root.locals.env}-resources.yaml"))
    common_vars = yamldecode(file("${get_parent_terragrunt_dir()}/azure/conf.d/prod-accounts/prod-a/prod-a-resources.yaml"))
}

inputs = {
    parent_id           = "${get_env("TF_VAR_PARENT_ID", "")}"
    resource_group_name = include.root.locals.env_vars.common.resource_group_name
    name                = include.root.locals.env_vars.common.name
    location            = include.root.locals.region
    address_space       = include.root.locals.env_vars.vnet.address_space
    public              = include.root.locals.env_vars.vnet.subnets.public
    private             = include.root.locals.env_vars.vnet.subnets.private
    public_routes       = include.root.locals.env_vars.vnet.public_routes
    private_routes      = include.root.locals.env_vars.vnet.private_routes
}