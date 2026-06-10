# =========================
# LAUNCH TEMPLATE
# =========================

resource "aws_launch_template" "web" {

  name_prefix = "web"

  # Substituir por uma AMI válida
  image_id = "us-east-1"

  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash

yum update -y
yum install -y httpd

echo "<h1>Servidor criado pelo Terraform</h1>" > /var/www/html/index.html

systemctl enable httpd
systemctl start httpd
EOF
)
}

# =========================
# AUTO SCALING GROUP
# =========================

resource "aws_autoscaling_group" "web" {

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  launch_template {

    id = aws_launch_template.web.id

    version = "$Latest"
  }

  health_check_type = "ELB"
}