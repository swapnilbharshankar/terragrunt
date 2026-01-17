terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/key-pair/aws//?version=2.1.1"
}


include "root" {
    path   = find_in_parent_folders("root.hcl")
    expose = true
}


inputs = {
    key_name        = include.root.locals.env_vars.ec2.key.name
    public_key      = file("${include.root.locals.env_vars.ec2.key.path}")
}