provider "aws" {
  region     = "us-east-2"
  access_key = "access key"
  secret_key = "secret key"
}
resource "aws_instance" "k8slave1" {
  ami           ="ami-003932de22c285676"
  instance_type = "t2.medium"
  key_name = "newkey"
  tags = {
    Name = "k8master"
  }
}

resource "aws_instance" "k8slave2" {
  ami           ="ami-003932de22c285676"
  instance_type = "t2.medium"
  key_name = "newkey"
  tags = {
    Name = "k8slave2"
  }
}
resource "aws_instance" "k8slave3" {
  ami           ="ami-003932de22c285676"
  instance_type = "t2.medium"
  key_name = "newkey"
  tags = {
    Name = "k8slave3"
