resource "aws_instance" "green" {
  count                  = var.enable_green_env ? var.green_instance_count : 0
  ami                    = data.aws_ami.image.id
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    region     = var.region
    PORT_1     = 80
    PORT_2     = 8080
    id         = data.aws_caller_identity.current.account_id
    repo       = "terraform-packer-docker-project"
    version    = var.application_version
    deployment = "green"
    count      = count.index
  })

  tags = {
    Name = "version-${var.application_version}-${count.index} (green)"
  }
}

resource "aws_lb_target_group" "green_target_group" {
  name     = "green-tg-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "green_tg_attachment" {
  count            = length(aws_instance.green)
  target_group_arn = aws_lb_target_group.green_target_group.arn
  target_id        = aws_instance.green[count.index].id
  port             = 80
}
