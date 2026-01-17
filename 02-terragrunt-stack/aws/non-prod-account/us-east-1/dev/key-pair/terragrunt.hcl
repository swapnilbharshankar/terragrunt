terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/key-pair/aws//?version=2.1.1"
}


include "root" {
    path   = find_in_parent_folders("root.hcl")
    expose = true
}


inputs = {
    key_name           = "swapnil-${include.root.locals.account_name}-${include.root.locals.env}"
    public_key = file("~/.ssh/id_ed25519.pub")
}