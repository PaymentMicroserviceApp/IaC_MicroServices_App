
data "aws_availability_zones" "available_zones" {}


resource "aws_vpc" "infrastructure_vpc" {
  cidr_block = var.vpc_cdir
  enable_dns_support = true
}

resource "aws_subnet" "private_subnet_mysql" {
  count = 2
  vpc_id = aws_vpc.infrastructure_vpc.id
  cidr_block = var.private_subnet_cdir_blocks[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
}

resource "aws_route_table" "private_mysql_route_table" {
  vpc_id = aws_vpc.infrastructure_vpc.id
}

resource "aws_route_table_association" "private" {
  count = 2
  route_table_id = aws_route_table.private_mysql_route_table.id
  subnet_id = aws_subnet.private_subnet_mysql[count.index].id
}


module "MySQL" {
  source = "./modules/MySQL"
}

