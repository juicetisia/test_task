resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "eu-central-1b"
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  depends_on = [
    // Important bit is here
    aws_lb.test
  ]
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnet_mapping {
    subnet_id     = aws_subnet.main_subnet.id
  }
  subnet_mapping {
    subnet_id     = aws_subnet.second_subnet.id
  }
}

resource "aws_lb_listener" "lb_listener_http" {
   load_balancer_arn    = aws_lb.test.id
   port                 = "80"
   protocol             = "HTTP"
   default_action {
    target_group_arn = aws_lb_target_group.lb_tg.id
    type             = "forward"
  }
}
