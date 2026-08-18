variable "app_instance_type" {
  default = "t3.medium"
}

variable "worker_instance_type" {
  default = "t3.small"
}

variable "db_instance_class" {
  default = "db.m5.large"
}

variable "db_allocated_storage" {
  default = 200
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_security_group" "app" {
  vpc_id = aws_vpc.main.id
}

resource "aws_instance" "app" {
  instance_type = var.app_instance_type
  subnet_id     = aws_subnet.app.id
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
}

resource "aws_instance" "worker" {
  instance_type = var.worker_instance_type
  subnet_id     = aws_subnet.app.id
  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }
}

resource "aws_ebs_volume" "data" {
  size       = 500
  type       = "gp3"
  availability_zone = "ap-northeast-2a"
}

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.app.id
}

resource "aws_db_instance" "main" {
  instance_class      = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  engine              = "mysql"
  storage_type        = "gp3"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "tfprice-demo-artifacts"
}

resource "aws_kms_key" "app" {}

resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  instance_type = "t3.medium"
}

resource "aws_autoscaling_group" "web" {
  desired_capacity = 4
  min_size         = 4
  max_size         = 6
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

resource "aws_elasticache_cluster" "cache" {
  cluster_id      = "demo-cache"
  engine          = "redis"
  node_type       = "cache.t3.medium"
  num_cache_nodes = 2
}

resource "aws_sqs_queue" "events" {
  name = "demo-events"
}
