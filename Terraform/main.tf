
data "aws_availability_zones" "available_zones" {}

module "MySQL" {
  source = "./modules/MySQL"
}