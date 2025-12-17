#!/bin/bash
set -e  # Exit on error

# Log user_data execution
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting user_data script execution at $(date)"

# Update system
sudo yum update -y

# Install packages
sudo yum install -y git jq unzip

# Install Docker
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker

# Add ssm-user to docker group
sudo usermod -aG docker ssm-user

echo "User_data script completed successfully at $(date)"