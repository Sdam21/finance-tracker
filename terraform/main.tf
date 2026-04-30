terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

#VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "finance-tracker-vpc"
    }
}

#Public subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "finance-tracker-pubic"
    }
}

#Private subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "finance-tracker-private"
    }
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "finance-tracker-private2"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "finance-tracker-igw"
    }
}

#ECR Repository
resource "aws_ecr_repository" "finance_tracker" {
    name = "finance_tracker"
    image_tag_mutability = "MUTABLE"
    force_delete = true

    image_scanning_configuration {
        scan_on_push = true
    }

    tags = {
        Name = "finance-tracker-ecr"
    }
}

#ECS Cluster
resource "aws_ecs_cluster" "main" {
    name = "finance-tracker-cluster"

    tags = {
        Name = "finance-tracker-cluster"
    }
}

#ECS Task Definition
resource "aws_ecs_task_definition" "finance_tracker" {
    family = "finance-tracker"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_execution_role.arn

    container_definitions = jsonencode([{
        name = "finance-tracker"
        image = "398050108341.dkr.ecr.us-east-1.amazonaws.com/finance_tracker:latest"
        portMappings = [{
      containerPort = 5000
      hostPort      = 5000
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/finance-tracker"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
    }])
}

# IAM Role for ECS
resource "aws_iam_role" "ecs_execution_role" {
  name = "finance-tracker-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "finance_tracker" {
  name = "/ecs/finance-tracker"
  retention_in_days = 7
}

#Route Table 
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
       Name = "finance-tracker-pubic-rt"
    }
}

#Route Table Association
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}