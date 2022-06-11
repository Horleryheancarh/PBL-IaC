# create instance for jenkins
resource "aws_instance" "Jenkins" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = var.subnets_compute
  vpc_security_group_ids      = var.sg_compute
  associate_public_ip_address = true
  key_name                    = var.keypair

 tags = merge(
    var.tags,
    {
      Name = "Yheancarh-Jenkins"
    },
  )
}


#create instance for sonbarqube
resource "aws_instance" "sonbarqube" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  subnet_id                   = var.subnets_compute
  vpc_security_group_ids      = var.sg_compute
  associate_public_ip_address = true
  key_name                    = var.keypair


   tags = merge(
    var.tags,
    {
      Name = "Yheancarh-sonbarqube"
    },
  )
}

# create instance for artifactory
resource "aws_instance" "artifactory" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  subnet_id                   = var.subnets_compute
  vpc_security_group_ids      = var.sg_compute
  associate_public_ip_address = true
  key_name                    = var.keypair


  tags = merge(
    var.tags,
    {
      Name = "Yheancarh-artifactory"
    },
  )
}