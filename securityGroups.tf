resource "aws_security_group" "sg_bastion" {
  name        = "secG-jorgelievanos_rampup-bastion"
  description = "Group rules for bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.main]
  tags       = var.aws_default_tags

}

resource "aws_security_group" "sg_alb_ui" {
  name        = "secG-jorgelievanos_rampup-alb-ui"
  description = "Group rules for ui alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.main]
  tags       = var.aws_default_tags

}

resource "aws_security_group" "sg_ui" {
  name        = "secG-jorgelievanos_rampup-ui"
  description = "Group rules for ui"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3030
    to_port         = 3030
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_alb_ui.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.sg_alb_ui, aws_security_group.sg_bastion]
  tags       = var.aws_default_tags

}

resource "aws_security_group" "sg_alb_api" {
  name        = "secG-jorgelievanos_rampup-alb-api"
  description = "Group rules for api alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_ui.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.sg_ui]
  tags       = var.aws_default_tags

}

resource "aws_security_group" "sg_api" {
  name        = "secG-jorgelievanos_rampup-api"
  description = "Group rules for api servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_alb_api.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.sg_alb_api, aws_security_group.sg_bastion]
  tags       = var.aws_default_tags

}
