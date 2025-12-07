data "aws_region" "current" {}

data "aws_prefix_list" "ssm" {
  name = "com.amazonaws.${data.aws_region.current.name}.ssm"
}

data "aws_prefix_list" "ec2messages" {
  name = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
}

data "aws_prefix_list" "ssmmessages" {
  name = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
}
