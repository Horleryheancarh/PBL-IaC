output "ALB_sg" {
  value = aws_security_group.Yheancarh["ext_alb_sg"].id
}

output "IALB_sg" {
  value = aws_security_group.Yheancarh["int_alb_sg"].id
}

output "bastion_sg" {
  value = aws_security_group.Yheancarh["bastion_sg"].id
}

output "nginx_sg" {
  value = aws_security_group.Yheancarh["nginx_sg"].id
}

output "web_sg" {
  value = aws_security_group.Yheancarh["webserver_sg"].id
}

output "datalayer_sg" {
  value = aws_security_group.Yheancarh["datalayer_sg"].id
}