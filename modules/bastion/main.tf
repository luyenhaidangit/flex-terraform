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

  tags = var.tags
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
  final_ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux_2023[0].id
}

############################################
# 4. EC2 Instance (NO PUBLIC IP)
############################################

resource "aws_instance" "bastion" {
  ami                     = local.final_ami
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.security_group_ids
  iam_instance_profile    = aws_iam_instance_profile.bastion_profile.name
  disable_api_termination = true
  monitoring              = var.enable_detailed_monitoring

  associate_public_ip_address = false # BEST PRACTICE (private only)

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
    encrypted   = true
    iops        = 3000
    throughput  = 125
  }

  lifecycle {
    ignore_changes = [ami] # Prevent replacement when AMI updates
  }

  tags = merge(var.tags, {
    Name = "${var.name}-bastion"
  })
}
