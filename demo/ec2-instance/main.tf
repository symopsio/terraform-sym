data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

# Create a security group with no ingress rules
resource "aws_security_group" "sg" {
  vpc_id = data.aws_subnet.selected.vpc_id
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group_rule" "http_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_instance" "instance" {
  ami                    = var.ami_id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  instance_type          = "t2.micro"
  monitoring             = true
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.instance_name,
    (var.tag_key) = (var.tag_value)
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = var.instance_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_role_name
  role = aws_iam_role.instance_role.name
}

