module "db" {
    source                      = "terraform-aws-modules/rds/aws"
    version                     = "7.1.0"
    identifier                  = var.identifier
    engine                      = var.engine
    engine_version              = var.engine_version
    family                      = "mysql8.0"
    major_engine_version        = var.engine_version
    instance_class              = var.instance_class
    allocated_storage           = var.allocated_storage

    db_name                     = var.db_name
    username                    = var.username
    password_wo                 = var.password # Use a more secure method for production

    # Network and security settings
    vpc_security_group_ids      = [aws_security_group.rds-sg.id]
    create_db_subnet_group      = true
    subnet_ids                  = var.subnet_ids

    # Configuration for a simple, non-production setup
    multi_az                    = false
    publicly_accessible         = false
    deletion_protection         = false
    skip_final_snapshot         = true
    tags                        = var.tags
}
# resource "aws_db_instance" "rds" {
#     identifier              = var.identifier
#     engine                  = var.engine
#     engine_version          = var.engine_version
#     instance_class          = var.instance_class
#     allocated_storage       = var.allocated_storage

#     db_name                 = var.db_name
#     username                = var.username
#     password                = var.password # Use a more secure method for production

#     # Network and security settings
#     vpc_security_group_ids  = [aws_security_group.rds-sg.id]
#     create_db_subnet_group  = true
#     subnet_ids              = var.subnet_ids

#     # Configuration for a simple, non-production setup
#     multi_az                = false
#     publicly_accessible     = false
#     deletion_protection     = false
#     skip_final_snapshot     = true
# }

resource "aws_security_group" "rds-sg" {
    name        = var.identifier
    description = "Allow traffic from EC2"
    vpc_id      = var.vpc_id
    # depends_on = [
    #     aws_vpc.two-tier-vpc
    # ]

    ingress {
        from_port   = "3360"
        to_port     = "3360"
        protocol    = "tcp"
        cidr_blocks = var.private_cidr_blocks # Allow HTTP traffic from anywhere
    }

    # Egress rules (allow outgoing traffic)
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1" # Allow all outgoing traffic
        cidr_blocks = ["0.0.0.0/0"] # Allow traffic to anywhere
    }
}

