# Tìm Security Group hiện có dựa trên tên
data "aws_security_group" "existing_sg" {
  name = "NewSecurityGroup" # Thay bằng tên SG thực tế trên AWS của bạn
}

# 1. Máy Jenkins + Harbor + Nginx (t3.medium, 30GB)
resource "aws_instance" "jenkins_harbor" {
  ami                    = var.ami_id
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name    = "Jenkins-Harbor-Server"
    Role    = "jenkins"
    Project = "todolist"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname jenkins-harbor
              EOF
}

# 2. Máy Kubernetes Master (control-plane)
resource "aws_instance" "k8s_master" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name    = "K8s-Control-Plane"
    Role    = "k8s_master"
    Project = "todolist"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname control-plane
              EOF
}

# 3. Hai máy Kubernetes Worker (node1 và node2)
resource "aws_instance" "k8s_workers" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name    = "K8s-Worker-${count.index + 1}"
    Role    = "k8s_worker"
    Project = "todolist"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname node${count.index + 1}
              EOF
}

# 4. Máy chủ cơ sở dữ liệu MongoDB (t3.micro)
resource "aws_instance" "mongodb" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name    = "MongoDB-Server"
    Role    = "mongodb"
    Project = "todolist"
  }
}

# 5. Máy chủ Giám sát Grafana + Prometheus (t3.small)
resource "aws_instance" "monitoring_server" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name    = "Monitoring-Server"
    Role    = "monitoring"
    Project = "todolist"
  }
}

# BỘ ĐẦU RA HIỂN THỊ IP SAU KHI KHỞI TẠO XONG
output "jenkins_harbor_public_ip" {
  value       = aws_instance.jenkins_harbor.public_ip
  description = "IP công khai máy chủ Jenkins + Harbor"
}

output "k8s_master_public_ip" {
  value       = aws_instance.k8s_master.public_ip
  description = "IP công khai Kubernetes Master Node"
}

output "k8s_workers_public_ips" {
  value       = aws_instance.k8s_workers[*].public_ip
  description = "Danh sách IP công khai các máy Kubernetes Worker"
}

output "mongodb_public_ip" {
  value       = aws_instance.mongodb.public_ip
  description = "IP công khai máy chủ MongoDB"
}

output "monitoring_public_ip" {
  value       = aws_instance.monitoring_server.public_ip
  description = "IP công khai máy chủ Giám sát"
}
