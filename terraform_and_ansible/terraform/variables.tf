variable "key_name" {
  default = "newKeyPair"
}

variable "ami_id" {
  default = "ami-04b70fa74e45c3917"
}

variable "sg_id" {
  default = "NewSecurityGroup" # Dùng tên SG để tham chiếu, Terraform sẽ tự tìm ID
}