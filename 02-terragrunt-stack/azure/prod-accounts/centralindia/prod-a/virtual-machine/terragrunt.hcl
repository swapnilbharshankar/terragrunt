terraform {
    source = "git::https://github.com/swapnilbharshankar/infrastructureascode-terraform//azure/virtual-machine?ref=azure-vm-0.0.8"
    #source = "${get_terragrunt_dir()}/../modules/virtual-machine/"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

dependency "network" {
  config_path = "../network"
}

inputs = {
    vnet_name = include.root.locals.env_vars.common.name
    name = include.root.locals.env_vars.virtual_machines[0].name
    resource_group_name = include.root.locals.env_vars.common.resource_group_name
    location = include.root.locals.region
    username = include.root.locals.env_vars.virtual_machines[0].username
    public_key_path = include.root.locals.env_vars.virtual_machines[0].public_key_path
    source_image_reference = include.root.locals.env_vars.virtual_machines[0].source_image_reference
    subnet_name = include.root.locals.env_vars.virtual_machines[0].subnet_name
}

