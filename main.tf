terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
#replace for the alb dns or domain
output "ui_public_ip" {
  value = aws_lb.alb_ui.dns_name
}