# Create subnet group for RDS
resource "aws_db_subnet_group" "yheancarh_rds_subnet" {
  name       = "yheancarh_rds_subnet"
  subnet_ids = [aws_subnet.private_subnet[2].id, aws_subnet.private_subnet[3].id]

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
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.yheancarh_rds_subnet.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer_sg.id]
  multi_az               = true
}