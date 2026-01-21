variable ami {
  type        = string
  default     = "ami-0ff8a91507f77f867"
  description = "provide an ami id"
}

variable key_name {
  type        = string
  description = "provide a key_name"
}

variable subnet_id {
  type        = string
  description = "provide a subnet id"
}

variable security_groups {
  type = set(string)
  description = "provide a security_groups"
}

variable name {
  type        = string
  description = "provide a name"
}

variable tags {
  type        = map(string)
  description = "provide a tags"
}

