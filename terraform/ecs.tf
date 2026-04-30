resource "aws_security_group" "ecs" {
    name = "finance-tracker-ecs-sg"
    description = "allow inbound traffic to ECS"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "finance-tracker-ecs-sg"
    }
}

resource "aws_ecs_service" "finance_tracker" {
    name = "finance-tracker-service"
    cluster = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.finance_tracker.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = [aws_subnet.public.id]
        security_groups = [aws_security_group.ecs.id]
        assign_public_ip = true
    }

    tags = {
        Name = "finance-tracker-service"
    }
}