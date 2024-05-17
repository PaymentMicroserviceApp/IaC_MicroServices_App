provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_security_group" "sg-mysql" {
  name        = "sg-mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [] - security group of the EKS
  }
}


resource "aws_db_instance" "mysql" {
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"

  storage_type = "gp2"
  allocated_storage = 20
  identifier = "mysql-db"
  db_name = "db_operation"

  skip_final_snapshot          = true
  multi_az                     = false
  backup_retention_period      = 0
  delete_automated_backups     = true
  publicly_accessible          = true
  performance_insights_enabled = false

  vpc_security_group_ids = [aws_security_group.sg-mysql.id]
  db_subnet_group_name = var.db_subnet_group_name

  tags = {
    project = "IaC_Microservices_App"
    created_by = "PaymentMicroserviceApp"
  }

  username = var.database_username
  password = var.database_password

}