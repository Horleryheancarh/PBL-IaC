# create instance for jenkins
resource "aws_instance" "Jenkins" {
  ami                         = var.ami-jenkins
  instance_type               = "t2.micro"
  subnet_id                   = var.subnets_compute
  vpc_security_group_ids      = var.sg_compute
  associate_public_ip_address = true
  key_name                    = var.keypair

 tags = merge(
    var.tags,
    {
      Name = "Yheancarh-jenkins"
    },
  )
}


#create instance for sonbarqube
resource "aws_instance" "sonbarqube" {
  ami                         = var.ami-sonar
  instance_type               = "t2.medium"
  subnet_id                   = var.subnets_compute
  vpc_security_group_ids      = var.sg_compute
  associate_public_ip_address = true
  key_name                    = var.keypair

   tags = merge(
    var.tags,
    {
      Name = "Yheancarh-sonarqube"
    },
  )
}

# create instance for artifactory
resource "aws_instance" "artifactory" {
  ami                         = var.ami-jfrog
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