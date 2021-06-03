data "template_file" "setup_api" {
  template = file("./provisions/setup-api.tpl")
}


resource "aws_instance" "api" {
  ami           = var.ami_ubuntu
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  subnet_id              = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg_api.id]

  user_data = data.template_file.setup_api.rendered

  depends_on = [aws_subnet.subnet_private, aws_security_group.sg_api]

  tags = merge(
    var.aws_default_tags,
    {
      Name = "ec2-jorgelievanos_rampup-api"
    },
  )

  volume_tags = merge(
    var.aws_default_tags,
    {
      Name = "ebs-jorgelievanos_rampup-api"
    },
  )
}

data "template_file" "setup_ui" {
  template = file("./provisions/setup-ui.tpl")
  vars = {
    host_ip = aws_instance.api.private_ip
  }
}

resource "aws_instance" "ui" {
  ami           = var.ami_ubuntu
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  subnet_id              = aws_subnet.subnet_public.id
  vpc_security_group_ids = [aws_security_group.sg_ui.id]

  user_data = data.template_file.setup_ui.rendered

  depends_on = [aws_subnet.subnet_public, aws_security_group.sg_ui, aws_instance.api]

  tags = merge(
    var.aws_default_tags,
    {
      Name = "ec2-jorgelievanos_rampup-ui"
    },
  )

  volume_tags = merge(
    var.aws_default_tags,
    {
      Name = "ebs-jorgelievanos_rampup-ui"
    },
  )
}