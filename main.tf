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

output "api_deploy" {
  value = aws_autoscaling_group.asg_api_blue.desired_capacity > 0 ? "blue" : "green"
}

output "ui_deploy" {
  value = aws_autoscaling_group.asg_ui_blue.desired_capacity > 0 ? "blue" : "green"
}