output "queue_url" {
  description = "URL de la file SQS"
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "ARN de la file SQS"
  value       = aws_sqs_queue.this.arn
}
