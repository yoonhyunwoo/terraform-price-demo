variable "instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "web" {
  instance_type = var.instance_type
  root_block_device {
    volume_size = 20
  }
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "tfprice-demo-artifacts"
}
