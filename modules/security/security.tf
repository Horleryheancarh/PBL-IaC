# Creating Dynamic Ingress Security Groups
locals {
  security_groups = {
    ext_alb_sg = {
      name        = "ext_alb_sg"
      description = "for external loadbalncer"
    }

    # security group for bastion
    bastion_sg = {
      name        = "bastion_sg"
      description = "for bastion instances"
    }

    # security group for nginx
    nginx_sg = {
      name        = "nginx_sg"
      description = "nginx instances"
    }

    # security group for IALB
    int_alb_sg = {
      name        = "int_alb_sg"
      description = "IALB security group"
    }

    # security group for webservers
    webserver_sg = {
      name        = "webserver_sg"
      description = "webservers security group"
    }

    # security group for data_layer
    datalayer_sg = {
      name        = "datalayer_sg"
      description = "data layer security group"
    }

    # security group for compute
    compute_sg = {
      name        = "compute_sg"
      description = "compute security group"
    }
  }
}