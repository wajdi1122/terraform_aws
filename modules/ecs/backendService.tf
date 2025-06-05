resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "1024"
  memory                  = "2048"
  execution_role_arn      = aws_iam_role.task_exec_role.arn
  task_role_arn           = aws_iam_role.task_exec_role.arn 

  container_definitions = jsonencode([{
  name  = "backend"
  image = "wajdi1999/back-end-app:latest"
  portMappings = [{
    containerPort = 8080
    hostPort      = 8080
  }]
  environment = [
    { name = "SPRING_APPLICATION_NAME", value = "back-end" },
    { name = "SPRING_DATASOURCE_URL", value = "jdbc:postgresql://${var.db_host}:5432/iovision_db" },
    { name = "SPRING_DATASOURCE_USERNAME", value = "postgres" },
    { name = "SPRING_DATASOURCE_PASSWORD", value = "mysecretpassword" },
    { name = "JAVA_TOOL_OPTIONS", value = "-Xms512m -Xmx1024m" },
    { name = "SPRING_JPA_HIBERNATE_DDL_AUTO", value = "update" },
    { name = "SPRING_JPA_SHOW_SQL", value = "true" },
    { name = "SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT", value = "org.hibernate.dialect.PostgreSQLDialect" },
    { name = "AWS_SQS_QUEUEURL", value = "${var.queue_url}" },
    { name = "SPRING_PROFILES_ACTIVE", value = "prod" }
  ],
   logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group" = "/ecs/backend",
        "awslogs-region" = "eu-north-1",
        "awslogs-stream-prefix" = "ecs"
      }
    }
  
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

resource "aws_lb_target_group" "backend_tg" {
  name        = "backend-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/actuator/health"
    matcher             = "200"
  }
}
