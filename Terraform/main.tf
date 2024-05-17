
data "aws_availability_zones" "available_zones" {}


resource "aws_vpc" "infrastructure_vpc" {
  cidr_block = var.vpc_cdir
  enable_dns_support = true
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.infrastructure_vpc.id
  cidr_block = var.private_subnet_cdir_blocks[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.infrastructure_vpc.id
}

resource "aws_route_table_association" "private" {
  count = 2
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet[count.index].id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
}


module "MySQL" {
  source = "./modules/MySQL"
  access_key = ""
  secret_key = ""
  database_password = ""
  database_username = ""
  vpc_id = aws_vpc.infrastructure_vpc.id
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
}

module "PostgreSQL" {
  source = "./modules/Postgres"
  secret_key        = ""
  access_key        = ""
  database_password = ""
  database_username = ""
  vpc_id = aws_vpc.infrastructure_vpc.id
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
}

module "MongoDB" {
  source = "./modules/DocumentDB"
  secret_key        = ""
  access_key        = ""
  database_password = ""
  database_username = ""
  vpc_id = aws_vpc.infrastructure_vpc.id
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
}
