data "template_file" "setup_api" {
  template = file("./provisions/setup-api.tpl")
}

resource "aws_launch_template" "lt_api" {
  name                   = "lt-jorgelievanos_rampup-api"
  image_id               = var.ami_ubuntu
  instance_type          = "t2.micro"
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.sg_api.id]
  user_data              = base64encode(data.template_file.setup_api.rendered)
  depends_on             = [aws_security_group.sg_api]
  tag_specifications {
    resource_type = "instance"
    tags          = var.aws_default_tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = var.aws_default_tags
  }

}

data "template_file" "setup_ui" {
  template = file("./provisions/setup-ui.tpl")
  vars = {
    host_ip = aws_lb.alb_api.dns_name
  }
}

resource "aws_launch_template" "lt_ui" {
  name                   = "lt-jorgelievanos_rampup-ui"
  image_id               = var.ami_ubuntu
  instance_type          = "t2.micro"
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.sg_ui.id]
  user_data              = base64encode(data.template_file.setup_ui.rendered)
  depends_on             = [aws_security_group.sg_ui]
  tag_specifications {
    resource_type = "instance"
    tags          = var.aws_default_tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = var.aws_default_tags
  }

}