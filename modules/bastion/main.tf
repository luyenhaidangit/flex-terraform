############################################
# 1. Security Group (NO INBOUND – SSM Only)
############################################

resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-bastion-sg"
  description = "Security Group for Bastion Host (SSM only)"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-bastion-sg"
  })
}

# Outbound only → 443 (SSM, EC2Messages, SSMMessages)
resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

# Optional: DNS lookup (recommended)
resource "aws_security_group_rule" "egress_dns" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

############################################
# 2. IAM Role for EC2 → SSM Access
############################################

resource "aws_iam_role" "bastion_role" {
  name = "${var.name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.name}-bastion-profile"
  role = aws_iam_role.bastion_role.name
}

############################################
# 3. AMI Lookup (Supports Override)
############################################

locals {
  final_ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux[0].id
}

############################################
# 4. EC2 Instance (NO PUBLIC IP)
############################################

resource "aws_instance" "bastion" {
  ami                     = local.final_ami
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.bastion_sg.id]
  iam_instance_profile    = aws_iam_instance_profile.bastion_profile.name
  disable_api_termination = true
  
  associate_public_ip_address = false  # BEST PRACTICE (private only)

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(var.tags, {
    Name = "${var.name}-bastion"
  })
}
