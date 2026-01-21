variable identifier {
  type        = string
  description = "provide an identifier name"
}

variable engine {
  type        = string
  default     = "mysql"
  description = "provide a mysql engine"
}
variable engine_version {
  type        = string
  default     = "8.0"
  description = "provide an engine_version"
}

variable instance_class {
  type        = string
  default     = "db.t3.micro"
  description = "provide an instance_class"
}

variable allocated_storage {
  default     = 20
  description = "provide an allocated_storage"
}

variable db_name {
  type        = string
  description = "provide a db_name"
}

variable username {
  type        = string
  description = "provide an username"
}

variable password {
  type        = string
  description = "provide an password"
  sensitive   = true
}

# variable vpc_security_group_ids {
#   description = "provide a vpc_security_group_ids"
# }

variable vpc_id {
  type        = string
  description = "provide a vpc id"
}

variable subnet_ids {
  type = set(string)
  description = "provide a subnet_ids"
}


variable private_cidr_blocks {
  type = set(string)
  description = "provide a private_cidr_blocks"
}

variable tags {
  type        = map(string)
  description = "provide a tags"
}




