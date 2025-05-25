output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}


output "ecs_backend_service_name" {
  description = "Nom du service backend ECS"
  value       = aws_ecs_service.backend_service.name  
}

output "ecs_frontend_service_name" {
  description = "Nom du service frontend ECS"
  value       = aws_ecs_service.frontend_service.name  
}
