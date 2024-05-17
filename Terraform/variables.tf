variable "resource_group_name_prefix" {
  type = string
  default = "rg_"
}

variable "resource_group_location" {
  type = string
  default = "eu-west-1"
  description = "Location of the resource group"
}

variable "repository_names"{
  type = list(string)
  default = ["my-repo"]
  description = "List of repository names"
}

variable "ec2_user_data" {
  type = string
  description = "User data to be executed on the EC2 instance"
  default = <<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
    EOT

}

variable "vpc_cdir" {
  type = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}