# =========================
# APPLICATION LOAD BALANCER
# =========================

resource "aws_lb" "web" {

  name = "prod-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

# =========================
# TARGET GROUP
# =========================

resource "aws_lb_target_group" "web" {

  name = "prod-tg"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {

    path = "/"

    healthy_threshold = 2

    unhealthy_threshold = 2

    timeout = 5

    interval = 30
  }
}

# =========================
# LISTENER HTTP
# =========================

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.web.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.web.arn
  }
}