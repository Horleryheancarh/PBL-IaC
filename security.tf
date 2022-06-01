#########################################
## Create External ALB security group  ##
#########################################
resource "aws_security_group" "ext_alb_sg" {
  name        = "ext_alb_sg"
  description = "allow HTTP and HTTPS traffic from anywhere"
  vpc_id      = aws_vpc.main.id

  # Inbound Traffic
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "Ext_ALB_sg"
    }
  )
}

# Add rule to allow ssh access from bastion_sg
resource "aws_security_group_rule" "inbound_ext_alb_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.ext_alb_sg.id
}


####################################
## Create Bastion security group  ##
####################################
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "allow SSH access from anywhere"
  vpc_id      = aws_vpc.main.id

  # Inbound Traffic
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "Bastion_sg"
    }
  )
}


################################################
## Create Nginx reverse proxy security group  ##
################################################
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.main.id

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "Nginx_sg"
    }
  )
}

# Add rule to allow http traffic from ext_alb_sg
resource "aws_security_group_rule" "inbound_nginx_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ext_alb_sg.id
  security_group_id        = aws_security_group.nginx_sg.id
}

# Add rule to allow https traffic from ext_alb_sg
resource "aws_security_group_rule" "inbound_nginx_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ext_alb_sg.id
  security_group_id        = aws_security_group.nginx_sg.id
}

# Add rule to allow ssh access from bastion_sg
resource "aws_security_group_rule" "inbound_nginx_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.nginx_sg.id
}


#########################################
## Create Internal ALB security group  ##
#########################################
resource "aws_security_group" "int_alb_sg" {
  name   = "int_alb_sg"
  vpc_id = aws_vpc.main.id

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "Int_ALB_sg"
    }
  )
}

# Add rule to allow http traffic from nginx_sg
resource "aws_security_group_rule" "inbound_int_alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nginx_sg.id
  security_group_id        = aws_security_group.int_alb_sg.id
}

# Add rule to allow https traffic from nginx_sg
resource "aws_security_group_rule" "inbound_int_alb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nginx_sg.id
  security_group_id        = aws_security_group.int_alb_sg.id
}


########################################
## Create Web Servers security group  ##
########################################
resource "aws_security_group" "webserver_sg" {
  name   = "webserver_sg"
  vpc_id = aws_vpc.main.id

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "WebServer_sg"
    }
  )
}

# Add rule to allow http traffic from int_alb_sg
resource "aws_security_group_rule" "inbound_web_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.int_alb_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}

# Add rule to allow https traffic from int_alb_sg
resource "aws_security_group_rule" "inbound_web_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.int_alb_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}

# Add rule to allow ssh access from bastion_sg
resource "aws_security_group_rule" "inbound_webserver_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}


#######################################
## Create Data Layer security group  ##
#######################################
resource "aws_security_group" "datalayer_sg" {
  name   = "datalayer_sg"
  vpc_id = aws_vpc.main.id

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "Datalayer_sg"
    }
  )
}

# Add rule to allow NFS traffic from webserver_sg
resource "aws_security_group_rule" "inbound_nfs_port" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id        = aws_security_group.datalayer_sg.id
}

# Add rule to allow MySQL traffic from webserver_sg
resource "aws_security_group_rule" "inbound_webserver_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id        = aws_security_group.datalayer_sg.id
}

# Add rule to allow MySQL access from bastion_sg
resource "aws_security_group_rule" "inbound_datalayer_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.datalayer_sg.id
}