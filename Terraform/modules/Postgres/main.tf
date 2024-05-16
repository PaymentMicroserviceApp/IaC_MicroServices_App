provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "sg-postgres" {
  name        = "sg-postgres"
  description = "Allow Postgres inbound traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  tags = {
    project = "IaC_Microservices_App"
    created_by = "PaymentMicroserviceApp"
  }

  username = var.database_username
  password = var.database_password

}