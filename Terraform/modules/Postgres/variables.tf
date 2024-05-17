variable "access_key" {
  description = "The AWS access key"
  type        = string
}

variable "secret_key" {
  description = "The AWS secret key"
  type        = string
}

variable "database_username"{
  description = "The username for the Postgres database"
  type        = string
}

variable "database_password"{
  description = "The password for the Postgres database"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "db_subnet_group_name"{
  description = "The name of the DB subnet group"
  type        = string
}