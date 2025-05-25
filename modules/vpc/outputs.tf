output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id  # Retourne une liste
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private[*].id  # Retourne une liste
}

output "first_public_subnet_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public[0].id  # Retourne un string
}

output "first_private_subnet_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private[0].id  # Retourne un string
}

output "web_sg_id" {
  description = "Web Security Group ID"
  value       = aws_security_group.web_sg.id
}

output "db_sg_id" {
  description = "Database Security Group ID"
  value       = aws_security_group.db_sg.id
}
