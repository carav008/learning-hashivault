# Create Application Load Balancer 
resource "aws_lb" "application-lb" {
  provider           = aws.region_master
  name               = "vault-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.vault_subnet1.id, aws_subnet.vault_subnet2.id]
  tags = {
    Name = "VaultAppLB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region_master
  name        = "app-lb-tg"
  port        = 8200
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_master.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = 8200
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "vault-target-group"
  }
}

resource "aws_lb_listener" "vault-listener-http" {
  provider          = aws.region_master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}

resource "aws_lb_target_group_attachment" "vault-attach" {
  provider         = aws.region_master
  count            = var.node_count
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = "${element(split(",", join(",", aws_instance.vault-node.*.id)), count.index )}"
  port             = 8200
}
