terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

output "ui_public_ip" {
  value = aws_instance.ui.public_ip
}