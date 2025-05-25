resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = aws_iam_role.task_exec_role.arn
  task_role_arn           = aws_iam_role.task_exec_role.arn  # Ajout du rôle IAM

  container_definitions = jsonencode([{
    name  = "backend"
    image = "wajdi1999/back-end-app:latest"
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    environment = [
      { name = "DB_HOST", value = var.db_host },
      { name = "SPRING_PROFILES_ACTIVE", value = "prod" }
    ]
  }])
}

resource "aws_ecs_service" "backend_service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = false
    subnets          = var.private_subnets
    security_groups  = [var.security_group_id]
  }
}
