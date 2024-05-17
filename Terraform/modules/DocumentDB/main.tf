provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "sg-documentdb" {
  name        = "sg-documentdb"
  description = "Allow DocumentDB inbound traffic"
  vpc_id       = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [] - security group of the EKS
  }
}

resource "aws_docdb_cluster" "documentdb_cluster" {
  cluster_identifier = "docdb-cluster-demo"
  availability_zones = ["us-west-2a"]
  master_username    = var.database_username
  master_password    = var.database_password
  vpc_security_group_ids = [aws_security_group.sg-documentdb.id]
  db_subnet_group_name = var.db_subnet_group_name
}

resource "aws_docdb_cluster_instance" "documentdb_instance" {
  count              = 1
  identifier         = "docdb-database"
  cluster_identifier = aws_docdb_cluster.documentdb_cluster.id
  instance_class     = "db.r5.large"

  tags = {
    project = "IaC_Microservices_App"
    created_by = "PaymentMicroserviceApp"
  }
}