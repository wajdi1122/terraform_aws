# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "iovision-cluster"

  tags = {
    Name = "iovision-cluster"
  }
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}

# IAM Role pour ECS Task Execution
resource "aws_iam_role" "task_exec_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

