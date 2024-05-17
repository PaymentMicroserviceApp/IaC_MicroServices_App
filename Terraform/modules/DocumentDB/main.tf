provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "sg-documentdb" {
  name        = "sg-documentdb"
  description = "Allow DocumentDB inbound traffic"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster" "documentdb_cluster" {
  cluster_identifier = "docdb-cluster-demo"
  availability_zones = ["us-west-2a"]
  master_username    = var.database_username
  master_password    = var.database_password
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