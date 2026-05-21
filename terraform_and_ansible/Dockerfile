# Sử dụng Ubuntu 24.04 mới nhất
FROM ubuntu:24.04

# Thiết lập chế độ không tương tác khi cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# 1. Cập nhật và cài đặt các gói cơ bản
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    python3 \
    python3-pip \
    sshpass \
    openssh-client \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# 2. Cài đặt Terraform (Bản chính thức từ Hashicorp)
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

# 3. Cài đặt Ansible và thư viện AWS (Boto3) cho Python
# Sử dụng --break-system-packages để cài trực tiếp trên Ubuntu 24.04
RUN pip3 install --no-cache-dir --break-system-packages \
    ansible \
    boto3 \
    botocore

# 4. Cài đặt AWS CLI (Để kiểm tra tài khoản và máy chủ nhanh)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws

# 5. Cài đặt Ansible Collection cho AWS
RUN ansible-galaxy collection install amazon.aws

# 6. Thiết lập thư mục làm việc
WORKDIR /root/project

# 7. SCRIPT TỰ ĐỘNG SỬA LỖI (Quan trọng nhất)
# - Sửa lỗi permission cho ansible.cfg
# - Copy file .pem vào thư mục nội bộ /root/.ssh để tránh lỗi mount từ Windows
# - Set chmod 400 cho file key để SSH không từ chối
# Sửa lại script bashrc để chuẩn hóa quyền hạn ngay tại thư mục project
RUN echo 'echo "--- Dang toi uu hoa moi truong DevOps ---"' >> /root/.bashrc && \
    echo 'chmod 755 /root/project/ansible 2>/dev/null' >> /root/.bashrc && \
    echo 'chmod 644 /root/project/ansible/ansible.cfg 2>/dev/null' >> /root/.bashrc && \
    echo 'find /root/project -name "*.pem" -exec chmod 400 {} \;' >> /root/.bashrc && \
    echo 'export ANSIBLE_CONFIG=/root/project/ansible/ansible.cfg' >> /root/.bashrc && \
    echo 'echo "Done! Moi thu da san sang."' >> /root/.bashrc

# Lệnh mặc định khi vào container
CMD ["/bin/bash"]