provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "sg-postgres" {
  name        = "sg-postgres"
  description = "Allow Postgres inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [] - security group of the EKS
  }
}

resource "aws_db_instance" "postgres" {
  engine = "postgres"
  engine_version = "14"
  instance_class = "db.t3.micro"

  storage_type = "gp2"
  allocated_storage = 20
  identifier = "postgres-db"
  db_name = "db_invoice"

  skip_final_snapshot          = true
  multi_az                     = false
  backup_retention_period      = 0
  delete_automated_backups     = true
  publicly_accessible          = true
  performance_insights_enabled = false

  vpc_security_group_ids = [aws_security_group.sg-postgres.id]
  db_subnet_group_name = var.db_subnet_group_name

  tags = {
    project = "IaC_Microservices_App"
    created_by = "PaymentMicroserviceApp"
  }

  username = var.database_username
  password = var.database_password

}