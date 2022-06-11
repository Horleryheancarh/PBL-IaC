# Create subnet group for RDS
resource "aws_db_subnet_group" "yheancarh_rds_subnet" {
  name       = "yheancarh_rds_subnet"
  subnet_ids = var.private_subnets

  tags = merge(
    var.tags,
    {
      Name = "Yheancarh-rds"
    }
  )
}

# Create RDS with the subnet group 
resource "aws_db_instance" "yheancarh_rds_instance" {
  allocated_storage      = 10
  engine                 = "mysql"
  storage_type           = "gp2"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "yheancarh_db"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.yheancarh_rds_subnet.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.db_sg]
  multi_az               = true
}