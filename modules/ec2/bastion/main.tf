############################################
# 1. AMI Lookup (Supports Override)
############################################

locals {
  final_ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux[0].id
}

############################################
# 2. EC2 Instance (NO PUBLIC IP)
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
    volume_size = var.volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(var.tags, {
    Name = "${var.name}-bastion"
  })
}
