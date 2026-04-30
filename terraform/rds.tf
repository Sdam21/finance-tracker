variable "db_password" {
    description = "RDS password"
    type = string 
    sensitive = true
    default = "changeme123!"
}

#DB Subnet Group
resource "aws_db_subnet_group" "main" {
    name = "finance-tracker-db-subnet"
    subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]

    tags = {
        Name = "finance-tracker-db-subnet"
    }
}

#Security Group for RDS
resource "aws_security_group" "rds" {
    name = "finance-tracker-rds-sg"
    description ="allow PstgreSQL from ECS only"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [aws_security_group.ecs.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "finance-tracker-rds-sg"
    }
}

#RDS Instance
resource "aws_db_instance" "postgres" {
    identifier = "finance-tracker-db"
    engine = "postgres"
    engine_version = "15"
    instance_class = "db.t3.micro"
    allocated_storage = 20

    db_name = "financetracker"
    username = "dbadmin"
    password = var.db_password

    db_subnet_group_name = aws_db_subnet_group.main.name
    vpc_security_group_ids = [aws_security_group.rds.id]

    skip_final_snapshot = true
    publicly_accessible = false

    tags = {
        Name = "finacne-tracker-db"
    }
}