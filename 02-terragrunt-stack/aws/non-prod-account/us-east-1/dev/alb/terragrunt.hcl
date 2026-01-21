terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/alb/aws?version=10.5.0"
}


include "root" {
    path   = find_in_parent_folders("root.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "ec2" {
  config_path = "../ec2"
      mock_outputs = {
          ec2_output = "mock-ec2-output"
      }

}

inputs = {
    name    = include.root.locals.env_vars.common.name
    vpc_id  = dependency.vpc.outputs.vpc_id
    subnets = dependency.vpc.outputs.public_subnets
    enable_deletion_protection = false
    security_group_ingress_rules = {
        all_http = {
            from_port   = 80
            to_port     = 80
            ip_protocol = "tcp"
            description = "HTTP web traffic"
            cidr_ipv4   = "0.0.0.0/0"
        }
        all_https = {
            from_port   = 443
            to_port     = 443
            ip_protocol = "tcp"
            description = "HTTPS web traffic"
            cidr_ipv4   = "0.0.0.0/0"
        }
    }
    security_group_egress_rules = {
        all = {
            ip_protocol = "-1"
            cidr_ipv4   = "0.0.0.0/0"
        }
    }
    listeners = {
        ex-http = {
            port            = 80
            protocol        = "TCP"

            forward = {
                target_group_key = "ex-instance"
            }
        }
    }
    target_groups = {
        ex-instance = {
            name_prefix      = "h1"
            protocol         = "TCP"
            port             = 80
            target_type      = "instance"
            target_id        = dependency.ec2.outputs.id
        }
    }
}
