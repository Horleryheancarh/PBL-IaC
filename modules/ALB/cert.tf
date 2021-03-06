# Create certificate for all domains in yheancarh.tk
resource "aws_acm_certificate" "yheancarh_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

# Call the hosted zone
data "aws_route53_zone" "yheancarh_zone" {
  name         = "yinkadevops.tk"
  private_zone = false
}

# DNS validation - Writing the DNS validation record to Route53
resource "aws_route53_record" "yheancarh_record" {
  for_each = {
    for dvo in aws_acm_certificate.yheancarh_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.yheancarh_zone.zone_id
}

# Validate the certificate using DNS
resource "aws_acm_certificate_validation" "yheancarh_cert_val" {
  certificate_arn         = aws_acm_certificate.yheancarh_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.yheancarh_record : record.fqdn]
}

# Create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.yheancarh_zone.zone_id
  name    = var.tooling_domain
  type    = "A"

  alias {
    name                   = aws_lb.ext_alb.dns_name
    zone_id                = aws_lb.ext_alb.zone_id
    evaluate_target_health = true
  }
}

# Create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.yheancarh_zone.zone_id
  name    = var.wordpress_domain
  type    = "A"

  alias {
    name                   = aws_lb.ext_alb.dns_name
    zone_id                = aws_lb.ext_alb.zone_id
    evaluate_target_health = true
  }
}
