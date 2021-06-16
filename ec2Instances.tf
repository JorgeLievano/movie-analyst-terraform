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

resource "aws_autoscaling_group" "asg_api" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 0
  #availability_zones = var.availability_zones
  vpc_zone_identifier = values(aws_subnet.subnet_private).*.id
  #vpc_zone_identifier = [for net in aws_subnet.subnet_private : net.id]
  target_group_arns   = [aws_lb_target_group.tg_api.arn]
  launch_template {
    id      = aws_launch_template.lt_api.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.lt_api, aws_lb_target_group.tg_api]
  #tag = var.aws_default_tags
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

resource "aws_autoscaling_group" "asg_ui" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 0
  #availability_zones = var.availability_zones
  #vpc_zone_identifier = aws_subnet.subnet_private[*].id
  vpc_zone_identifier = [for net in aws_subnet.subnet_private : net.id]
  target_group_arns   = [aws_lb_target_group.tg_ui.arn]
  launch_template {
    id      = aws_launch_template.lt_ui.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.lt_ui]
  #tag = var.aws_default_tags

}