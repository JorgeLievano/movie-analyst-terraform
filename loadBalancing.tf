resource "aws_lb" "alb_api" {
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb_api.id]
  subnets            = [for net in aws_subnet.subnet_private : net.id]
  depends_on         = [aws_security_group.sg_alb_api, aws_subnet.subnet_private]
  name               = "alb-jorgelievanos-api"
  tags               = var.aws_default_tags
}

resource "aws_lb_target_group" "tg_api" {
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = 3000
    protocol = "HTTP"
  }
  tags = merge(
    var.aws_default_tags,
    {
      Name = "alb-jorgelievanos_rampup-private"
    },
  )

}

resource "aws_lb_listener" "lstnr_api" {
  load_balancer_arn = aws_lb.alb_api.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_api.arn
  }
  depends_on = [aws_lb.alb_api, aws_lb_target_group.tg_api]
}

resource "aws_lb" "alb_ui" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb_ui.id]
  subnets            = [for net in aws_subnet.subnet_public : net.id]
  depends_on         = [aws_security_group.sg_alb_ui, aws_subnet.subnet_public]
  name               = "alb-jorgelievanos-ui"
  tags               = var.aws_default_tags
}

resource "aws_lb_target_group" "tg_ui" {
  port     = 3030
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = 3030
    protocol = "HTTP"
  }
  tags = merge(
    var.aws_default_tags,
    {
      Name = "alb-jorgelievanos_rampup-private"
    },
  )

}

resource "aws_lb_listener" "lstnr_ui" {
  load_balancer_arn = aws_lb.alb_ui.arn
  port              = "3030"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_ui.arn
  }
  depends_on = [aws_lb.alb_ui, aws_lb_target_group.tg_ui]
}