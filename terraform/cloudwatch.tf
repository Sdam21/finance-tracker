
#CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
    alarm_name = "finance-tracker-cpu-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = 60
    statistic = "Average"
    threshold = 80
    alarm_description = "ECS CPU usage above 80%"

    dimensions = {
        ClusterName = "finance-tracker-cluster"
        ServiceName = "finance-tracker-service"
    }
}

#Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
    alarm_name = "finance-tracker-memory-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "MemoryUtilization"
    namespace = "AWS/ECS"
    period = 60
    statistic = "Average"
    threshold = 80
    alarm_description = "ECS memory usage above 80%"

    dimensions = {
        ClusterName = "finance-tracker-cluster"
        ServiceName = "finance-tracker-service"
    }
}

#RDS CPU Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
    alarm_name = "finance-tracker-rds-cpu-high"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/RDS"
    period = 60
    statistic = "Average"
    threshold = 80
    alarm_description = "RDS CPU usage above 80%"

    dimensions = {
        DBInstanceIdentifier = "finance-tracker-db"
    }
}