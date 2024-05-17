
data "aws_availability_zones" "available_zones" {}



module "ECR_Repositories"{
  source = "./modules/ECR"
  for_each = var.repository_names
  repository_name = each.key
  access_key = ""
  secret_key = ""
}