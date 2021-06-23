resource "aws_autoscaling_group" "asg_api_blue" {
  name             = "asg-api-blue"
  desired_capacity = var.api_blue_enable ? 2 : 0
  max_size         = 3
  min_size         = 0
  #availability_zones = var.availability_zones
  vpc_zone_identifier = values(aws_subnet.subnet_private).*.id
  #vpc_zone_identifier = [for net in aws_subnet.subnet_private : net.id]
  target_group_arns = var.api_blue_running ? [aws_lb_target_group.tg_api.arn] : null
  launch_template {
    id      = aws_launch_template.lt_api.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.lt_api, aws_lb_target_group.tg_api]
  #tag = var.aws_default_tags
}

resource "aws_autoscaling_group" "asg_ui_blue" {
  name             = "asg-ui-blue"
  desired_capacity = var.ui_blue_enable ? 2 : 0
  max_size         = 3
  min_size         = 0
  #availability_zones = var.availability_zones
  #vpc_zone_identifier = aws_subnet.subnet_private[*].id
  vpc_zone_identifier = [for net in aws_subnet.subnet_private : net.id]
  target_group_arns   = var.ui_blue_running ? [aws_lb_target_group.tg_ui.arn] : null
  launch_template {
    id      = aws_launch_template.lt_ui.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.lt_ui]
  #tag = var.aws_default_tags
}